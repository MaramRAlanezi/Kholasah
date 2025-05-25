//
//  TermsAndConditions.swift
//  Kholasah
//
//  Created by Shaden Alhumood on 27/11/1446 AH.
//

import SwiftUI

struct TermsAndConditions: View {
    
    @State private var isAgreed: Bool = false
    
    var body: some View {
        ZStack {
            // Background Color
            Color(red: 246/255, green: 246/255, blue: 246/255)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(spacing: 16) {
                    
                if #available(iOS 14.0, *) {
                        Text("Terms and Conditions")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    } else {
                        // Fallback on earlier versions
                    }
                    

                    // Last Updated (outside the box)
                    Text("Last Updated: 25 May")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    // Main Text Box
                    VStack(alignment: .leading, spacing: 8) {
                        Group {
                            Text("Welcome to Kholasah. By using our app, you agree to the following terms:")
                                .fontWeight(.medium)

                            sectionTitle("1. Service Overview")
                            paragraph("Kholasah allows users to record meetings or upload audio files to generate summaries and reports. Audio is processed temporarily—we do not store audio files after processing.")

                            sectionTitle("2. User Responsibility")
                            paragraph("You must have the right to record or upload any audio you use with the app. You are solely responsible for your content and for complying with local laws (e.g., obtaining consent to record).")

                            sectionTitle("3. Data Handling")
                            paragraph("""
                            • Audio Files: Not stored. Used only for real-time processing.
                            • Summaries & Reports: May be saved for your access. You can delete them anytime.
                            • See our Privacy Policy for more on data use.
                            """)

                            sectionTitle("4. Acceptable Use")
                            paragraph("You agree not to use the app for unlawful purposes or to violate others’ rights. Misuse of the app may lead to suspension or termination of access.")

                            sectionTitle("5. No Guarantees")
                            paragraph("We provide the app “as is.” We don’t guarantee uninterrupted service or 100% accuracy of generated summaries.")

                            sectionTitle("6. Liability Limitation")
                            paragraph("We are not liable for any damages resulting from your use of the app, to the extent permitted by law.")

                            sectionTitle("7. Changes to Terms")
                            paragraph("We may update these Terms. If you continue using the app after changes, it means you accept the updated Terms.")

                            sectionTitle("Contact Us")
                            paragraph("Questions? Reach out at Kholasah.Ksa@gmail.com.")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)

                    // Custom Checkbox
                    Button(action: {
                        isAgreed.toggle()
                    }) {
                        HStack(spacing: 8) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .background(isAgreed ? Color(red: 235/255, green: 77/255, blue: 68/255) : Color.white)
                                    .frame(width: 24, height: 24)

                                if isAgreed {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }

                            Text("I agree to the Terms and Conditions")
                                .font(.footnote)
                                .foregroundColor(.gray)

                            Spacer()
                        }
                    }

                    // Agree Button
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        print("User agreed to the terms.")
                    }) {
                        Text("Agree")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isAgreed ? Color(red: 235/255, green: 77/255, blue: 68/255) : Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .disabled(!isAgreed)
                    .padding(.top, 8)
                }
                .padding()
            }
        }
    }
    
    
    
    // MARK: - Helpers

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.top, 4)
    }

    private func paragraph(_ text: String) -> some View {
        Text(text)
            .font(.footnote)
            .fixedSize(horizontal: false, vertical: true)
    }
}

    
    
// MARK: - Preview
struct Terms_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditions()
    }
}

