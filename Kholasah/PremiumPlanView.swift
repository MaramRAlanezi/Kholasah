//
//  PremiumPlanView.swift
//  Kholasah
//
//  Created by Wejdan Alghamdi on 18/11/1446 AH.
//

import SwiftUI

struct PremiumPlanView: View {
    var body: some View {
        VStack  {
            ZStack {
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    
                    Spacer().frame(height: 20) // 👈 Moves everything down 40 points
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Premium plan")
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color("navy"))
                        
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Flexible")
                            Text("• Unlimited meeting recording minutes.")
                            Text("• Customizable themes for a personalized experience.")
                            Text("• Additional report formats.")
                        }
                        .font(.body)
                        .foregroundColor(.navy)
                        .padding()
                        
                        VStack{
                            HStack(alignment: .firstTextBaseline, spacing: 4) {
                                Image("riyal")
                                    .resizable()
                                    .frame(width: 20, height: 18)
                                Text("39/month")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(Color("navy"))
                                
                            }
                            
                            Text("Pause or cancel anytime")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                        }
                        
                        .padding()
                        
                        Button(action: {
                            // Action here
                        }) {
                            HStack {
                                Text("Upgrade Now")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.white)
                      
                            }
                            .padding()
                            .frame(width: 320, height: 41)
                            .background(Color.redd)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    PremiumPlanView()
}
