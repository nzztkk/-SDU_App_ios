//
//  AuthLogic.swift
//  SDU App
//
//  Created by Nurkhat on 29.03.2025.
//

import SwiftUI
import Supabase

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var errorMessage: String?

    private var supabase: SupabaseClient?

    init() {
        if let config = loadSupabaseConfig() {
            guard let url = URL(string: config.url) else {
                print("❌ Ошибка: Неверный URL Supabase")
                return
            }
            supabase = SupabaseClient(supabaseURL: url, supabaseKey: config.key)
            print("✅ Supabase инициализирован успешно.")
        } else {
            print("❌ Ошибка: Не удалось загрузить конфиг Supabase")
        }
    }

    // ✅ Загрузка конфигов Supabase из Secrets.plist
    private func loadSupabaseConfig() -> (url: String, key: String)? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            print("❌ Файл Secrets.plist не найден.")
            return nil
        }

        guard let dict = NSDictionary(contentsOfFile: path) as? [String: Any],
              let url = dict["SUPABASE_URL"] as? String,
              let key = dict["SUPABASE_KEY"] as? String else {
            print("❌ Не удалось получить URL или ключ из Secrets.plist.")
            return nil
        }

        return (url, key)
    }

    // ✅ Авторизация пользователя через Supabase
    func login(email: String, password: String) async {
        guard let supabase = supabase else {
            print("❌ Supabase клиент не инициализирован.")
            return
        }

        do {
            let session = try await supabase.auth.signIn(email: email, password: password)
            // ✅ Успешный вход пользователя
            print("✅ Успешный вход пользователя: \(String(describing: session.user.email))")
            DispatchQueue.main.async {
                self.isLoggedIn = true
                self.errorMessage = nil
            }
        } catch {
            print("❌ Ошибка авторизации: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // ✅ Выход пользователя из системы
    func logout() async {
        guard let supabase = supabase else { return }

        do {
            try await supabase.auth.signOut()
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
            print("✅ Пользователь вышел из системы.")
        } catch {
            print("❌ Ошибка при выходе: \(error.localizedDescription)")
        }
    }
}

