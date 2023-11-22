//
//  HomeView.swift
//  Split
//
//  Created by Christos Eteoglou on 2023-11-22.
//

import SwiftUI

struct HomeView: View {
    @State var bill: CGFloat = 750
    @State var payers = [
        
        Payer(image: "animoji2", name: "Romanoff", bgColor: Color("animojiColor2")),
        Payer(image: "animoji1", name: "Calle", bgColor: Color("animojiColor1")),
        Payer(image: "animoji3", name: "Violet", bgColor: Color("animojiColor3"))
    ]
    
    @State var pay = false
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                
                HStack {
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundStyle(Color("card"))
                            .padding()
                            .background(Color.black.opacity(0.25))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    Spacer()
                }
                .padding()
                
                // MARK: Bill Card View
                VStack(spacing: 15) {
                    
                    Button {
                        
                    } label: {
                        Text("Receipt")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color("bg"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // MARK: Dotted Lines..
                    
                    Line()
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 1, lineCap: .butt, lineJoin: .miter, dash: [10]))
                        .frame(height: 1)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    HStack {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.caption)
                            
                            Text("Team Dinner")
                                .font(.title2)
                                .fontWeight(.heavy)
                        }
                        .foregroundStyle(Color("bg"))
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Total Bill")
                                .font(.caption)
                            
                            Text("$\(Int(bill))")
                                .font(.title2)
                                .fontWeight(.heavy)
                        }
                        .foregroundStyle(Color("bg"))
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    }
                    
                    // MARK: Memoji Views..
                    VStack {
                        HStack(spacing: -20) {
                            
                            ForEach(payers) { payer in
                                
                                Image(payer.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(8)
                                    .background(payer.bgColor)
                                    .clipShape(Circle())
                            }
                        }
                        
                        Text("Splitting with")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("bg"))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("card").clipShape(BillShape()).clipShape(RoundedRectangle(cornerRadius: 25)))
                .padding(.horizontal)
                
                ForEach(payers.indices, id: \.self) { index in
                    
                    PriceView(payer: $payers[index], totalAmount: bill)
                }
                
                Spacer(minLength: 25)
                
                // MARK: Pay Button
                HStack {
                    
                    HStack(spacing: 0) {
                        ForEach(1 ... 6, id: \.self) { index in
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundStyle(Color.white.opacity(Double(index) * 0.06))
                        }
                    }
                    .padding(.leading, 45)
                    
                    Spacer()
                    
                    Button {
                        pay.toggle()
                    } label: {
                        Text("Confirm Split")
                            .fontWeight(.bold)
                            .foregroundStyle(Color("card"))
                            .padding(.horizontal, 25)
                            .padding(.vertical)
                            .background(Color("bg"))
                            .clipShape(Capsule())
                    }
                }
                .padding()
                .background(Color.black.opacity(0.25))
                .clipShape(Capsule())
                .padding(.horizontal)
            }
        }
        .background(Color("bg").ignoresSafeArea())
        .confirmationDialog("Confirm To Split Pay", isPresented: $pay) {
            Button("Pay") {
                // Do Something Here..
            }
            
            Button("Cancel") {
                // Do Something Here..
            }
            .keyboardShortcut(.cancelAction)
        }
    }
}

// MARK: Price Split View
struct PriceView: View {
    @Binding var payer: Payer
    var totalAmount: CGFloat
    
    var body: some View {
        VStack(spacing: 15) {
            // MARK: Custom Slider
            HStack {
                
                Image(payer.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .padding(8)
                    .background(payer.bgColor)
                    .clipShape(Circle())
                
                Text(payer.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text(getPrice())
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
            }
            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                
                Capsule()
                    .fill(Color.black.opacity(0.25))
                    .frame(height: 30)
                
                Capsule()
                    .fill(payer.bgColor)
                    .frame(width: payer.offset + 20, height: 30)
                
                // MARK: Dots..
                HStack(spacing: (UIScreen.main.bounds.width - 100) / 12) {
                    
                    ForEach(0 ..< 12, id: \.self) { index in
                        
                        Circle()
                            .fill(Color.white)
                            .frame(width: index % 4 == 0 ? 7 : 4, height: index % 4 == 0 ? 7 : 4)
                    }
                }
                .padding(.leading)
                
                Circle()
                    .fill(Color("card"))
                    .frame(width: 35, height: 35)
                    .background(
                        Circle().stroke(Color.white, lineWidth: 5)
                    )
                    .offset(x: payer.offset)
                    .gesture(DragGesture().onChanged({ value in
                        
                        // IMPORTANT: Padding Horizontal = 30 - Circle Radius = 20 - Total = 50
    
                        if value.location.x > 20 && value.location.x <= UIScreen.main.bounds.width - 50 {
                            
                            // IMPORTANT: You cant drag the circle back to its initial zero position once moved, so Circle Radius = 20
                            payer.offset = value.location.x - 20
                        }
                    }))
            }
        }
        .padding()
    }
    
    // MARK: Calculating Price
    func getPrice() -> String {
        
        let percent = payer.offset / (UIScreen.main.bounds.width - 70)
        let amount = percent * (totalAmount / 3)
        
        return String(format: "%.2f", amount)
    }
}

// MARK: Custom Dotted Line Shape
struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}

// MARK: Custom Card Shape
struct BillShape: Shape {
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            
            path.move(to: CGPoint(x: 0, y: 80))
            path.addArc(center: CGPoint(x: 0, y: 80), radius: 20, startAngle: .init(degrees: -90), endAngle: .init(degrees: 90), clockwise: false)
            
            path.move(to: CGPoint(x: rect.width, y: 80))
            path.addArc(center: CGPoint(x: rect.width, y: 80), radius: 20, startAngle: .init(degrees: 90), endAngle: .init(degrees: -90), clockwise: false)
        }
    }
}

// MARK: Sample Model & Data
struct Payer: Identifiable {
    
    var id = UUID().uuidString
    var image: String
    var name: String
    var bgColor: Color
    
    // Offset For Custom Progress View
    var offset: CGFloat = 0
}

#Preview {
    HomeView()
}
