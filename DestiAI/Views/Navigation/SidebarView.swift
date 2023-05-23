//
//  Sidebar.swift
//  DestiAI
//
//  Created by Lorand Ignat on 20.04.2023.
//

import SwiftUI

struct SidebarView: View {
  
  @EnvironmentObject var navigationViewModel: NavigationViewModel
  @EnvironmentObject var suggestionViewModel: SuggestionViewModel
  
  var body: some View {
    List(selection: $navigationViewModel.selectedItem) {
      Section() {
        HStack {
          Spacer()
          Text("DestiAI")
#if os(macOS)
            .font(Font.custom("HelveticaNeue-Bold", size: 16))
#else
            .font(Font.custom("HelveticaNeue-Bold", size: 24))
#endif
            .foregroundColor(Color.primaryLight)
          Spacer()
        }
        .deleteDisabled(true)
        .tag(0)
        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
#if !os(macOS)
        .background(UIDevice.current.userInterfaceIdiom == .phone
                    ? (navigationViewModel.lastItemSelected == 0
                       ? Color.contrast : Color.primaryMedium)
                    : (navigationViewModel.selectedItem == 0 || navigationViewModel.selectedItem == nil
                       ? Color.contrast : Color.primaryMedium))
#else
        .background(navigationViewModel.selectedItem == 0 || navigationViewModel.selectedItem == nil
                    ? Color.contrast : Color.primaryMedium)
#endif
      }
      
      Section(header:
                HStack {
        Text(suggestionViewModel.suggestions.count > 0 ? "History" :
              "No search history")
        .foregroundColor(Color.primaryDark)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        Spacer()
      }) {
        ForEach(0..<suggestionViewModel.suggestions.count, id: \.self) { index in
          HStack {
            Text("\(suggestionViewModel.suggestions[index].date.getFormattedDate(format: "MMM dd")) - \(suggestionViewModel.suggestions[index].location)")
#if os(macOS)
              .font(Font.custom("HelveticaNeue-Bold", size: 12))
#else
              .font(Font.custom("HelveticaNeue-Bold", size: 16))
#endif
              .foregroundColor(Color.primaryLight)
              .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            Spacer()
            Image(systemName: "trash")
              .onTapGesture {
                delete(index: index)
              }
              .foregroundColor(Color.primaryLight)
              .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
          }
          .tag(index + 1)
          .listRowBackground(Color.primaryMedium)
#if !os(macOS)
          .background(UIDevice.current.userInterfaceIdiom == .phone
                      ? (navigationViewModel.lastItemSelected == index + 1
                         ? Color.contrast : Color.primaryMedium)
                      : (navigationViewModel.selectedItem == index + 1
                         ? Color.contrast : Color.primaryMedium))
#else
          .background(navigationViewModel.selectedItem == index + 1
                      ? Color.contrast : Color.primaryMedium)
#endif
        }
        .background(Color.primaryMedium)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
      }
    }
#if !os(macOS)
    .listStyle(.insetGrouped)
#endif
    .tint(Color.primaryMedium)
    .accentColor(Color.primaryMedium)
    .background(Color.primaryMedium)
    .scrollContentBackground(.hidden)
  }
  
  func delete(index: Int) {
    if navigationViewModel.lastItemSelected == index + 1 {
      navigationViewModel.selectedItem = index
    } else if navigationViewModel.lastItemSelected >= index {
      navigationViewModel.lastItemSelected -= 1
    }
    suggestionViewModel.remove(at: index)
  }
}

struct SidebarView_Previews: PreviewProvider {
  static var previews: some View {
    SidebarView()
      .environmentObject(NavigationViewModel())
      .environmentObject(SuggestionViewModel())
  }
}
