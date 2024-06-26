//
//  AccountView.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/29/24.
//

import SwiftUI
import AlertToast

enum AccountPage {
    case login
    case create
}

struct AccountView: View {
    var isTemporaryAuth: Bool
    @State private var authMethod: AccountPage = .login
    @StateObject private var userManager = UserDataManager.shared

    var body: some View {
        NavigationView(title: "Account") {
            selectPage()
        }
    }
    
    @ViewBuilder
    private func selectPage()  -> some View {
        if UserDataManager.shared.isLoggedIn() {
            AuthenticatedView(authMethod: $authMethod)
        } else {
            switch authMethod {
                case .login:
                    LoginView(authMethod: $authMethod, isTemporaryAuth: isTemporaryAuth)
                case .create:
                    CreateAccountView(authMethod: $authMethod, isTemporaryAuth: isTemporaryAuth)
            }
        }
    }
}

struct AuthenticatedView: View {
    @Binding var authMethod: AccountPage
    @StateObject private var userManager = UserDataManager.shared
    @State private var showFailure = false
    private let assignmentCount: Int
    private let completedAssignmentCount: Int

    init(authMethod: Binding<AccountPage>) {
        self._authMethod = authMethod
        let assignmentCounts = UserDataManager.shared.getAssignmentCounts()
        assignmentCount = assignmentCounts.0
        completedAssignmentCount = assignmentCounts.1

    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 20){
                Text("Welcome \(UserDataManager.shared.getName())")
                    .font(.largeTitle)
                VStack(alignment: .leading, spacing: 20){
                    Text("\(completedAssignmentCount) out of \(assignmentCount) assignments completed").font(.title3)
                    Text("Ranked \(UserDataManager.shared.getPosition()) for time spent working among users").font(.title3)
                }
                
                Button {
                    UserDataManager.shared.logout(onsuccess: {
                        authMethod = .login
                    }, onfailure: {
                        showFailure.toggle()
                    })
                    
                } label: {
                    Text("Log out")
                }
                Spacer()
            }
            Spacer()
        }.toast(isPresenting: $showFailure){
            AlertToast(type: .error(.red), title: "Unable to logout")
        }
    }
    
}

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode

    @Binding var authMethod: AccountPage
    var isTemporaryAuth: Bool
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showFailure = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            BorderedTextField(title: "Username", placeholder: "Enter username", text: $username)
            BorderedSecureField(title: "Password", placeholder: "Enter password", text: $password)
            ErrorText(error: "* Invalid username or password", showError: $showFailure)
            TextButton(title: "Login", foregroundColor: .white, backgroundColor: .pink, action: login)
            Button {
                authMethod = .create
            } label: {
                Text("Create account in instead")
            }
            Spacer()
        }.padding(20)
    }
    
    private func login() {
        UserDataManager.shared.login(username: username, password: password) { _ in
            
            if isTemporaryAuth {
                self.presentationMode.wrappedValue.dismiss()
            }
            
        } onfailure: {
            showFailure = true
        }

    }
}

struct CreateAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var authMethod: AccountPage
    var isTemporaryAuth: Bool
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showFailure = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            BorderedTextField(title: "Username", placeholder: "Enter username", text: $username)
            BorderedSecureField(title: "Password", placeholder: "Enter password", text: $password)
            ErrorText(error: "* Unable to create account", showError: $showFailure)
            TextButton(title: "Create Account", foregroundColor: .white, backgroundColor: .pink, action: createAccount)
            Button {
                authMethod = .login
            } label: {
                Text("Log in instead")
            }
            Spacer()
        }.padding(20)
    }
    
    private func createAccount() {

        UserDataManager.shared.createAccount(username: username, password: password) { _ in
            
            if isTemporaryAuth {
                self.presentationMode.wrappedValue.dismiss()
            }
        } onfailure: {
            showFailure = true
        }
    }
}

#Preview {
    AccountView(isTemporaryAuth: false)
}
