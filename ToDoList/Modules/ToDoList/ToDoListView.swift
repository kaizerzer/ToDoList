//
//  SwiftUIView.swift
//  ToDoList
//
//  Created by Anton Kaizer on 29.01.26.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject var viewState: ToDoListViewState
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @State var screenWidth: CGFloat = 0
    
    var body: some View {
        ZStack {
            List {
                ForEach($viewState.items) { $item in
                    ToDoItemCell(item: $item)
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.1)) {
                                self.viewState.itemToggled(&item)
                            }
                        }
                        .contextMenu(menuItems: {
                            ToDoItemContextMenu(item: item, viewState: viewState)
                        }, preview: {
                            ToDoItemCellContent(item: item, completed: false)
                                .padding()
                                .frame(idealWidth: screenWidth)
                            
                        })
                }
                .listSectionSeparator(.hidden, edges: .top)
                .listRowSeparatorTint(Color.appStroke)
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            
            GeometryReader { geometry in
                Color.clear.preference(key: ScreenWidthPreferenceKey.self, value: geometry.size.width)
            }
        }
        .onPreferenceChange(ScreenWidthPreferenceKey.self) { width in
            self.screenWidth = width
        }
        .navigationTitle("Задачи")
        .toolbar {
            ToDoToolbarContent(viewState: viewState)
        }
        .searchable(text: $viewState.searchText, placement: .navigationBarDrawer, prompt: "Поиск")
        .task {
            viewState.onAppear()
        }
    }
    struct ScreenWidthPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat { .zero }

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

struct ToDoToolbarContent: ToolbarContent {
    @ObservedObject var viewState: ToDoListViewState
    
    @ScaledMetric(relativeTo: .body) var toolbarFontSize: CGFloat = 11
    @ScaledMetric(relativeTo: .title) var toolbarIconSize: CGFloat = 17
    @ScaledMetric var toolbarIconLeadingPadding: CGFloat = 1
    @ScaledMetric var toolbarIconBottomPadding: CGFloat = 3
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Spacer()
            if viewState.loading {
                ProgressView()
            } else {
                Text(viewState.tasksCountPlural)
                    .font(.system(size: toolbarFontSize))
                    .fixedSize()
            }
            
            Spacer()
        }
        .liquidGlassNoBackground()
        ToolbarItem(placement: .bottomBar) {
            Button {
                self.viewState.createItem()
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(Color.accent)
                    .font(.system(size: toolbarIconSize))
                    .padding(.bottom, toolbarIconBottomPadding)
                    .padding(.leading, toolbarIconLeadingPadding)
            }
        }
    }
}

struct ToDoItemContextMenu: View {
    let item: ToDoItem
    @ObservedObject var viewState: ToDoListViewState
    
    @ScaledMetric(relativeTo: .title) var fontSize: CGFloat = 17
    
    var body: some View {
        Group {
            Button(action: {
                self.viewState.editItem(item)
            }) {
                Label("Редактировать", image: "context_menu_edit_icon")
            }
            ShareLink(item: item.title, message: item.description != nil ? Text(item.description!) : nil ){
                Label("Поделиться", image: "context_menu_share_icon")
            }
            Button(role: .destructive, action: {
                withAnimation(.linear(duration: 0.1)) {
                    self.viewState.deleteItem(item)
                }
            }) {
                Label("Удалить", image: "context_menu_delete_icon")
            }
        }
        .font(.system(size: fontSize))
    }
}

struct ToDoItemCellContent: View {
    let item: ToDoItem
    
    let completed: Bool
    
    @ScaledMetric(relativeTo: .title3) var titleFontSize: CGFloat = 16
    @ScaledMetric(relativeTo: .body) var bodyFontSize: CGFloat = 12
    
    @ScaledMetric var verticalPadding: CGFloat = 6
    
    var body: some View {
        VStack(alignment: .leading, spacing: verticalPadding) {
            Group {
                Text(item.title)
                    .font(.system(size: titleFontSize))
                    .strikethrough(completed)
                    .fontWeight(.medium)
                    .lineLimit(item.description == nil ? 2 : 1)
                    .opacity(completed ? 0.5 : 1.0)
                    .background(GeometryReader {  geometry in
                        Color.clear.preference(key: TitleHeightPreferenceKey.self, value: geometry.size.height)
                    })
                if let desc = item.description {
                    Text(desc)
                        .font(.system(size: bodyFontSize))
                        .fontWeight(.regular)
                        .lineLimit(2)
                    
                    .opacity(completed ? 0.5 : 1.0)
                }
                
                Text(item.date.formatted(date: .numeric, time:.omitted))
                    .font(.system(size: bodyFontSize))
                    .fontWeight(.regular)
                    .opacity(0.5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    struct TitleHeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat { .zero }

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

struct ToDoItemCell: View {
    @Binding var item: ToDoItem
    
    @State var titleTopPadding: CGFloat = 0.0
    @ScaledMetric var checkmarkCircleSize: CGFloat = 24
    @ScaledMetric var checkmarkWidth: CGFloat = 12
    @ScaledMetric var verticalPadding: CGFloat = 6
    @ScaledMetric var horizontalPadding: CGFloat = 20
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 8) {
                    ZStack(alignment: .center) {
                        Circle()
                            .stroke(item.completed ? Color.accent : Color.appStroke)
                        Image("checkmark_icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: checkmarkWidth)
                            .foregroundStyle(Color.accent)
                            .opacity(item.completed ? 1.0 : 0.0)
                    }
                    .frame(width: checkmarkCircleSize)
                    .alignmentGuide(.listRowSeparatorLeading) { d in
                        d[.leading]
                    }
                    
                    ToDoItemCellContent(item: item, completed: item.completed)
                    .padding(.top, titleTopPadding)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, verticalPadding * 2)
                .padding(.top, verticalPadding * 2 - titleTopPadding)
                
            }
            .onPreferenceChange(ToDoItemCellContent.TitleHeightPreferenceKey.self) { height in
                self.titleTopPadding = (checkmarkCircleSize - height)/2
            }
            .padding(.horizontal)
        }
    }
}

#if DEBUG

extension ToDoListView {
    static func mockState() -> ToDoListViewState {
        let state = ToDoListViewState()
        state.items.append(ToDoItem(id: "", title: "Уборка в квартире", description: "Провести генеральную уборку в квартире", completed: false, date: Date()))
        state.items.append(ToDoItem(id: "1", title: "Уборка в квартире уборка в квартире", description: "Провести генеральную уборку в квартире провести генеральную уборку в квартире провести генеральную уборку в квартире", completed: false, date: Date()))
        state.items.append(ToDoItem(id: "2", title: "Уборка в квартире", description: "Провести генеральную уборку в квартире", completed: false, date: Date()))
        state.items.append(ToDoItem(id: "3", title: "Уборка в квартире", description: "Провести генеральную уборку в квартире", completed: false, date: Date()))
        state.items.append(ToDoItem(id: "4", title: "Уборка в квартире", description: "Провести генеральную уборку в квартире", completed: false, date: Date()))
        return state
    }
}

#endif

#Preview {
    NavigationStack {
        ToDoListView(viewState: ToDoListView.mockState())
    }
}
