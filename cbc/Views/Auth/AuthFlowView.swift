//----------------------------------------------------------------------------
//File:       AuthFlowView.swift
//Project:     cbc
//Created by:  Celaya Solutions, 2025
//Author:      Christopher Celaya <chris@chriscelaya.com>
//Description: Authentication flow coordinator view
//Version:     1.0.0
//License:     MIT
//Last Update: November 2025
//----------------------------------------------------------------------------

#if os(iOS)
import SwiftUI

struct AuthFlowView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            switch viewModel.step {
            case .identity:
                IdentityEstablishmentView(
                    identifierText: $viewModel.identifierText,
                    onSubmit: {
                        viewModel.submitIdentifier()
                    },
                    onCancel: {
                        viewModel.cancel()
                    }
                )
                
            case .session:
                SessionResumeView(
                    accessKeyText: $viewModel.accessKeyText,
                    isLogin: viewModel.isLogin,
                    onSubmit: {
                        viewModel.submitAccessKey()
                    },
                    onBack: {
                        viewModel.goBack()
                    },
                    onCancel: {
                        viewModel.cancel()
                    }
                )
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AuthFlowView(viewModel: AuthViewModel())
}
#endif
