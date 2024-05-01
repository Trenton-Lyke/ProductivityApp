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

                Text("\(completedAssignmentCount) out of \(assignmentCount) assignments completed").font(.title3)
                Button {
                    UserDataManager.shared.logout()
                    authMethod = .login
                } label: {
                    Text("Log out")
                }
                Spacer()
            }
            Spacer()
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
        print("login button clicked: \(username); \(password)")
        UserDataManager.shared.login(username: username, password: password) { user in
            
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
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showFailure = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HStack{
                BorderedTextField(title: "First name", placeholder: "Enter first name", text: $firstName)
                BorderedTextField(title: "Last name", placeholder: "Enter last name", text: $lastName)
            }
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
        print("login button clicked: \(username); \(password)")
        UserDataManager.shared.createAccount(firstName: firstName, lastName: lastName, username: username, password: password) { user in
            
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
