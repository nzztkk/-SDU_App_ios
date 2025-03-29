import SwiftUI
import Supabase

@MainActor
    
    
struct ScreenLogin: View {
    @State private var studentID: String = ""
    @State private var password: String = ""
    @StateObject private var viewModel = AuthViewModel()
    @State private var isStudentIDValid: Bool = false // Для валидации ID
        
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Логотип
            Image("SDU_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.bottom, 20)
            
            Text("welcome".syswords)
                .font(.title2)
                .fontWeight(.bold)
            
            Text("use_portal_data".syswords)
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            // Поля ввода
            VStack(spacing: 16) {
                // Поле для студенческого ID (только цифры, максимум 9)
                TextField("sdu_id".syswords, text: $studentID)
                    .textContentType(.none) // Убираем автозаполнение
                    .keyboardType(.numberPad) // Только цифры
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .onChange(of: studentID) { newValue in
                        // Ограничиваем длину до 9 символов
                        if newValue.count > 9 {
                            studentID = String(newValue.prefix(9))
                        }
                        // Фильтруем только цифры
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue {
                            studentID = filtered
                        }
                        // Проверяем валидность
                        isStudentIDValid = studentID.count == 9 && studentID.allSatisfy { $0.isNumber }
                    }
                
                SecureField("password".syswords, text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
                
            // Кнопка входа
            Button(action: {
                Task {
                    await viewModel.login(email: studentID, password:password)
                }
            }) {
                Text("login_b".syswords)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isStudentIDValid && !password.isEmpty ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        .disabled(!isStudentIDValid || password.isEmpty) // Кнопка активна только при валидном ID и непустом пароле
                
            // Ошибка авторизации
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                }
                
            Spacer()
        
                // Политика конфиденциальности
            Text("privacy_policy".syswords)
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                
            // Кнопка выхода (если уже залогинен)
            if viewModel.isLoggedIn {
                Button(action: {
                    Task {
                        await viewModel.logout()
                    }
                }) {
                    Text("Выйти")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                if viewModel.isLoggedIn {
                    print("✅ Пользователь уже авторизован.")
                }
            }
        }
    }
}
#Preview {
    ScreenLogin()
}
