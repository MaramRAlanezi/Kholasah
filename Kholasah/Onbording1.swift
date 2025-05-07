import SwiftUI

struct Onbording1: View {
    @State private var currentPage = 0
    @State private var userName: String = ""
    @State private var goToHome = false

    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<3) { index in
                        ZStack {
                            Image("page\(index + 1)")
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea() // full-screen image
                                .frame(width: 550, height: 980)
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Button("Skip") {
                                        goToHome = true
                                    }
                                    .foregroundColor(Color("orange"))
                                    .padding(.top, 85)
                                    .padding(.trailing, 90)
                                }

                                Spacer()

                                if index == 0 {
                                    VStack {
                                        Text("Turn Meetings into\nActionable Insights")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(Color("dark"))
                                            .multilineTextAlignment(.center)
                                            .padding(.top, 50) // Adjust this value to move the text down

                                        Text("Upload or record your meetings, we’ll do                              the rest")
                                            .font(.body)
                                            .foregroundColor(Color("dark"))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                            .padding(.top, 10) // Adjust this value to move the text down
                                    }
                                } else if index == 1 {
                                    VStack {
                                        Text("From Conversation\nto Clarity")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(Color("dark"))
                                            .multilineTextAlignment(.center)
                                            .padding(.top, 50) // Adjust this value to move the text down

                                        Text("Our AI understands your meetings,                                                turning them into useful content")
                                            .font(.body)
                                            .foregroundColor(Color("dark"))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                            .padding(.top, 10) // Adjust this value to move the text down
                                    }
                                } else {
                                    VStack(spacing: 7) {
                                        Text("Firstly, what’s your name?")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(Color("dark"))
                                            .multilineTextAlignment(.center)
                                            .padding(.top, 420) // Adjust this value to move the text down
                                            .padding(.trailing, 25)

                                        ZStack{
                                            
                                            TextField("Your Name", text: $userName)
                                                .frame(width: 314, height: 20) // Increased height for better touch target
                                                .padding()
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(10)
                                                .padding(.horizontal)
                                                .padding(.top, 50) // Adjust this value to move the text field down
                                                .padding(.trailing, 30)
                                            
                                            
                                            // Clear button
                                            
                                            if !userName.isEmpty {
                                                Button(action: {
                                                    userName = ""
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.gray)
                                                        .padding(.leading, 270)
                                                        .padding(.top, 60)
                                                }
                                                
                                            }
                                        }
                                  

                                        Spacer() // Push the button to the bottom

                                        
                                        Button(action: {
                                            goToHome = true
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color("orange"))
                                                    .frame(width: 50, height: 50)

                                                Image(systemName: "arrow.right")
                                                    .foregroundColor(.white)
                                            }
                                        }
                                       // .padding(.bottom, 10) // Adjust this value to move the button up/down
                                        .padding(.leading, 250)
                                    }
                                }

                                Spacer()
                                indicatorView
                                    .padding(.bottom, 70)
                            }
                            .padding()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea() // Very important!

                NavigationLink(destination: HomeView(), isActive: $goToHome) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var indicatorView: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Capsule()
                    .fill(index == currentPage ? Color("orange") : Color.gray.opacity(0.3))
                    .frame(width: index == currentPage ? 20 : 8, height: 6)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    Onbording1()
}
