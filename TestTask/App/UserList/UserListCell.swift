//
//  UserListCell.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI
import DomainKit
import DesignSystemKit

struct UserListCell: View {
    @State var user: User
    @State var isLast: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            AsyncImage(url: URL(string: user.photo)) { phase in
                switch phase {
                case .empty, .failure:
                    Image("avatar_placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    @unknown default:
                        EmptyView()
                    }
            }
            Spacer()
                .frame(width: 16)
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(AppFonts.body2())
                Spacer().frame(height: 4)
                Text(user.position)
                    .font(AppFonts.body3())
                    .foregroundStyle(AppColors.textPrimary.opacity(0.6))
                    .lineLimit(1)
                Spacer().frame(height: 8)
                Text(user.email)
                    .font(AppFonts.body3())
                    .lineLimit(1)
                Text(user.phone)
                    .font(AppFonts.body3())
                Spacer().frame(height: 24)
                if !isLast {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(AppColors.primaryDisabled)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.background)
    }
}

struct UserListCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 0) {
            UserListCell(user: User.sample)
            UserListCell(user: User.sampleLong, isLast: true)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
