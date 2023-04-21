//
//  ContentView.swift
//  DestiAI
//
//  Created by Lorand Ignat on 18.04.2023.
//

import SwiftUI

struct InputView: View {
  
  @EnvironmentObject var inputViewModel: InputViewModel
  
  @State private var isScrollAnimation = false
  @State private var scrollUpOpacityAnimation = 0.0
  @State private var scrollDownOpacityAnimation = 0.0
  @State private var pagesScrolledAnimation = 0

  var body: some View {
    GeometryReader { geo in
      ZStack {
        Color.primaryLight.ignoresSafeArea()
        ScrollView(.vertical, showsIndicators: true) {
          VStack(spacing: 0) {
            WelcomeView()
              .frame(width: geo.size.width, height: geo.size.height)
              .environmentObject(inputViewModel)
            ForEach(0..<inputViewModel.numberOfQuestions(), id: \.self) { index in
              ZStack {
                Rectangle()
                  .fill(Color.primaryLight)
                  .frame(height: geo.size.height)
                QuestionsView(questionIndex: index)
                  .environmentObject(inputViewModel)
                  .frame(width: geo.size.width, height: geo.size.height)
              }
            }
            PromptView(onSearch: nil)
              .frame(width: geo.size.width, height: geo.size.height)
              .environmentObject(inputViewModel)
          }
        }
        .content.offset(y: -geo.size.height * CGFloat(pagesScrolledAnimation))
        .frame(maxHeight: .infinity)
      }.gesture(
        DragGesture()
          .onEnded { value in
            let delta = value.translation.height
            let sensitivity: CGFloat = 100
            if delta < -sensitivity && inputViewModel.currentPage < inputViewModel.pageCount - 1 && inputViewModel.currentPage < inputViewModel.maxPage {
              isScrollAnimation = true
              inputViewModel.currentPage += 1
            } else if delta > sensitivity && inputViewModel.currentPage > 0 {
              isScrollAnimation = true
              inputViewModel.currentPage -= 1
            }
          }
      )
      
      VStack {
        Text("↑ scroll up ↑")
          .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
          .font(Font.custom("HelveticaNeue", size: 12))
          .foregroundColor(.primaryMedium)
          .frame(width: geo.size.width)
          .multilineTextAlignment(.center)
          .transition(.asymmetric(insertion: .scale, removal: .scale))
          .opacity(scrollUpOpacityAnimation)
        Spacer()
        Text("↓ scroll down ↓")
          .font(Font.custom("HelveticaNeue", size: 12))
          .foregroundColor(.primaryMedium)
          .frame(width: geo.size.width)
          .multilineTextAlignment(.center)
          .transition(.asymmetric(insertion: .scale, removal: .scale))
          .opacity(scrollDownOpacityAnimation)
      }
    }
    .onChange(of: inputViewModel.currentPage) { newValue in
      let animate = {
        withAnimation(Animation.easeInOut(duration: 0.5)) {
          pagesScrolledAnimation = newValue
          scrollUpOpacityAnimation = newValue > 0 ? 1 : 0
          scrollDownOpacityAnimation = newValue < inputViewModel.maxPage ? 1 : 0
        }
      }
      if !isScrollAnimation {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
          animate()
        }
      } else {
        animate()
      }
      isScrollAnimation = false
    }
    .onAppear {
      pagesScrolledAnimation = inputViewModel.currentPage
      scrollUpOpacityAnimation = inputViewModel.currentPage > 0 ? 1 : 0
      scrollDownOpacityAnimation = inputViewModel.currentPage < inputViewModel.maxPage ? 1 : 0
    }
  }
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView()
      .environmentObject(InputViewModel())
  }
}