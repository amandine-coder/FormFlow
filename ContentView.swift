//
//  ContentView.swift
//  FormFlow
//
//  Created by Amandine on 18/04/26.
//

import SwiftUI

struct ContentView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    @State private var nameError = ""
    @State private var emailError = ""
    @State private var passwordError = ""
    
    @State private var isSubmitted = false
    
    // règles de validation
    var isNameValid: Bool { !name.isEmpty }
    var isEmailValid: Bool { email.contains("@") && email.contains(".") }
    var isPasswordValid: Bool { password.count >= 8 }
    var isFormValid: Bool { isNameValid && isEmailValid && isPasswordValid }

        var body: some View {
               NavigationStack {
                   ScrollView {
                       VStack(alignment: .leading, spacing: 24) {
                           
                           // champ nom
                           FieldView(
                               label: "Full name",
                               placeholder: "Amandine",
                               text: $name,
                               error: nameError,
                               isSecure: false
                           )
                           
                           // champ email
                           FieldView(
                               label: "Email",
                               placeholder: "hello@ambstudio.com",
                               text: $email,
                               error: emailError,
                               isSecure: false
                           )
                           
                           // champ mot de passe
                           FieldView(
                               label: "Password",
                               placeholder: "Min. 8 characters",
                               text: $password,
                               error: passwordError,
                               isSecure: true
                           )
                           
                           // bouton submit
                           Button {
                               validate()
                           } label: {
                               Text(isSubmitted ? "Account created ✓" : "Create account")
                                   .font(.headline)
                                   .foregroundStyle(.white)
                                   .frame(maxWidth: .infinity)
                                   .padding(.vertical, 16)
                                   .background(isFormValid ? Color.black : Color.gray)
                                   .cornerRadius(12)
                                   .animation(.spring(duration: 0.3), value: isFormValid)
                           }
                           .disabled(!isFormValid)
                       }
                       .padding(20)
                   }
                   .navigationTitle("Sign up")
               }
           }
           
           func validate() {
               // reset erreurs
               nameError = ""
               emailError = ""
               passwordError = ""
               
               // vérifie chaque champ
               if !isNameValid {
                   nameError = "Name is required"
               }
               if !isEmailValid {
                   emailError = "Enter a valid email address"
               }
               if !isPasswordValid {
                   passwordError = "Password must be at least 8 characters"
               }
               
               // si tout est valide
               if isFormValid {
                   withAnimation(.spring(duration: 0.4)) {
                       isSubmitted = true
                   }
               }
           }
       }


       // composant champ réutilisable
       struct FieldView: View {
           let label: String
           let placeholder: String
           @Binding var text: String
           let error: String
           let isSecure: Bool
           
           var body: some View {
               VStack(alignment: .leading, spacing: 6) {
                   
                   // label
                   Text(label)
                       .font(.subheadline)
                       .fontWeight(.medium)
                   
                   // champ
                   Group {
                       if isSecure {
                           SecureField(placeholder, text: $text)
                       } else {
                           TextField(placeholder, text: $text)
                       }
                   }
                   .padding(14)
                   .background(Color(.systemGray6))
                   .cornerRadius(10)
                   .overlay(
                       RoundedRectangle(cornerRadius: 10)
                           .stroke(error.isEmpty ? Color.clear : Color.red, lineWidth: 1.5)
                   )
                   
                   // message d'erreur
                   if !error.isEmpty {
                       Text(error)
                           .font(.caption)
                           .foregroundStyle(.red)
                           .transition(.opacity)
                   }
               }
           }
       }

#Preview {
    ContentView()
}
