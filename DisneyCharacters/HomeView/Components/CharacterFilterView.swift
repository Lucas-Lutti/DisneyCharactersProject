import SwiftUI

struct CharacterFilterView: View {
    @Binding var selectedTab: String
    @Binding var searchText: String // Estado para o texto do campo de pesquisa

    let tabs = ["Films", "Tv Shows", "Video Games", "Short Films"]

    var body: some View {
        VStack(spacing: 20) {
            // Tabs
            HStack(spacing: 10) {
                ForEach(tabs, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }) {
                        Text(tab)
                            .font(.system(size: 12))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 0)
                            .frame(maxWidth: .infinity)
                            .background(selectedTab == tab ? Color.indigo : Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, -10)
            
            // Input de pesquisa com ícone de lupa
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                TextField("", text: $searchText, prompt: Text("Search characters...")
                    .foregroundColor(.white)) // Placeholder branco
                    .textFieldStyle(PlainTextFieldStyle()) // Remove o estilo padrão
                    .font(.system(size: 14))
                    .foregroundColor(.white) // Texto digitado em branco
            }
            .padding(.vertical, 8) // Deixa mais fino verticalmente
            .padding(.horizontal, 12)
            .background(Color.gray.opacity(0.3))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1) // Borda mais sutil
            )
            .padding(.horizontal, 10)
        }
        .padding(.bottom, 20)
    }
}

// Preview da tela
struct CharacterFilterView_Previews: PreviewProvider {
    @State static var selectedTab = "Films"
    @State static var searchText = ""

    static var previews: some View {
        CharacterFilterView(selectedTab: $selectedTab, searchText: $searchText)
    }
}
