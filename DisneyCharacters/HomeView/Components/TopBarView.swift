import SwiftUI

struct TopBarView: View {
    var title: String
    var onSettingsTapped: () -> Void = {}

    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .ignoresSafeArea(edges: .top)

            HStack {
                Text(title)
                    .font(.custom("Waltograph", size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.leading, 16)

                Spacer()

                Button(action: onSettingsTapped) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(.trailing, 16)
                }
            }
            .frame(height: 60)
        }
        .frame(height: 40)
        .padding(.bottom, 25)
    }
}
