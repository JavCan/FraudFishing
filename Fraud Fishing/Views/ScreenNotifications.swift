//
//  ScreenNotifications.swift
//  Fraud Fishing
//
//  Created by Javier Canella Ramos on 01/10/25.
//

import SwiftUI

struct Notification: Identifiable {
    let id = UUID()
    let type: NotificationType
    let title: String
    let description: String
    let date: Date
}

enum NotificationType {
    case approved
    case inReview
    case denied
    
    var icon: String {
        switch self {
        case .approved:
            return "checkmark.circle.fill"
        case .inReview:
            return "clock.fill"
        case .denied:
            return "xmark.circle.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .approved:
            return .green
        case .inReview:
            return .blue
        case .denied:
            return .red
        }
    }
}

struct ScreenNotifications: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var controller = NotificacionesController()

    var body: some View {
        ZStack {
            backgroundGradient
            
            VStack(spacing: 0) {
                headerView
                contentView
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
        }
        .task {
            await controller.cargarNotificaciones(userId: 42)
        }
    }
    
    // MARK: - Subviews
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.043, green: 0.090, blue: 0.205, opacity: 0.89),
                Color(red: 0.043, green: 0.067, blue: 0.28)
            ]),
            startPoint: UnitPoint(x: 0.5, y: 0.7),
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private var headerView: some View {
        HStack {
            backButton
            
            Text("Notificaciones")
                .font(.poppinsMedium(size: 28))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding(.top)
        .padding(.bottom, 20)
    }
    
    private var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(Color(red: 0.0, green: 0.71, blue: 0.737))
                .clipShape(Circle())
        }
        .padding(.leading)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if controller.isLoading {
            loadingView
        } else if controller.notificacionesAgrupadas.isEmpty {
            EmptyNotificationsView()
        } else {
            notificationsList
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView("Cargando notificaciones...")
                .foregroundColor(.white)
                .padding(.top, 80)
            Spacer()
        }
    }
    
    private var notificationsList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(controller.notificacionesAgrupadas, id: \.date) { group in
                    NotificationGroupView(
                        date: group.date,
                        items: group.items,
                        header: header(for: group.date)
                    )
                }
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Función auxiliar para encabezado de sección
    private func header(for date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date) { return "Hoy" }
        if cal.isDateInYesterday(date) { return "Ayer" }

        let fmt = DateFormatter()
        fmt.dateFormat = "d 'de' MMMM"
        fmt.locale = Locale(identifier: "es_ES")
        return fmt.string(from: date)
    }
}

// MARK: - Notification Group View
struct NotificationGroupView: View {
    let date: Date
    let items: [NotificacionDTO]
    let header: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(header)
                .font(.poppinsSemiBold(size: 18))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.top, 8)
            
            groupContent
        }
    }
    
    private var groupContent: some View {
        VStack(spacing: 0) {
            ForEach(items, id: \.id) { noti in
                notificationItem(noti)
                
                if noti.id != items.last?.id {
                    itemDivider
                }
            }
        }
        .background(Color.white.opacity(0.08))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
    
    private func notificationItem(_ noti: NotificacionDTO) -> some View {
        NotificationRow(
            notification: Notification(
                type: .inReview,
                title: noti.title,
                description: noti.message,
                date: noti.createdAt
            )
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
    }
    
    private var itemDivider: some View {
        Divider()
            .background(Color.white.opacity(0.1))
            .padding(.leading, 75)
    }
}

// MARK: - Notification Row
struct NotificationRow: View {
    let notification: Notification

    var body: some View {
        HStack(spacing: 15) {
            iconView
            textContent
            Spacer()
            chevronIcon
        }
    }
    
    private var iconView: some View {
        Image(systemName: notification.type.icon)
            .font(.title2)
            .foregroundColor(notification.type.iconColor)
            .frame(width: 44, height: 44)
            .background(notification.type.iconColor.opacity(0.15))
            .clipShape(Circle())
    }
    
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(notification.title)
                .font(.poppinsSemiBold(size: 16))
                .foregroundColor(.white)
            
            Text(notification.description)
                .font(.poppinsRegular(size: 14))
                .foregroundColor(.gray)
                .lineLimit(2)
        }
    }
    
    private var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14))
            .foregroundColor(.gray.opacity(0.5))
    }
}

// MARK: - Empty State
struct EmptyNotificationsView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("ClearNoti")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
            
            Text("No tienes notificaciones nuevas")
                .font(.poppinsMedium(size: 22))
                .foregroundColor(.white)
                .padding(.top, 20)
                .multilineTextAlignment(.center)
            
            Text("Tus notificaciones aparecerán\naquí cuando las recibas.")
                .font(.poppinsRegular(size: 16))
                .foregroundColor(Color(red: 0.0, green: 0.71, blue: 0.737))
                .multilineTextAlignment(.center)
                .padding(.top, 2)
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    ScreenNotifications()
}
