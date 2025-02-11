import SwiftUI

struct ScreenLogin: View {
    @State private var studentID: String = ""
    @State private var password: String = ""
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Логотип из PDF
            
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
                TextField("sdu_id".syswords, text: $studentID)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                    .onChange(of: studentID) { newValue in
                        studentID = String(newValue.prefix(9)).filter { $0.isNumber }
                    }
                
                SecureField("passwrd".syswords, text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
            }
            
            // Кнопка входа
            Button(action: {
                if !studentID.isEmpty && !password.isEmpty {
                    isLoggedIn = true
                }
            }) {
                Text("login_b".syswords)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Политика конфиденциальности
            Text("privacy_policy".syswords)
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    ScreenLogin()
}
