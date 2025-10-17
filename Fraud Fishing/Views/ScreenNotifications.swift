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
    @State private var notifications: [Notification] = []
    @State private var showEmptyState: Bool = true

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 0.043, green: 0.067, blue: 0.173, opacity: 0.88),
                Color(red: 0.043, green: 0.067, blue: 0.173)]),
                           startPoint: UnitPoint(x:0.5, y:0.1),
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0.0, green: 0.71, blue: 0.737))
                            .clipShape(Circle())
                    }
                    .padding(.leading)
                    
                    Text("Notificaciones")
                        .font(.poppinsMedium(size: 28))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Botón de prueba para alternar vistas
                    Button(action: {
                        if showEmptyState {
                            notifications = [
                                Notification(type: .approved, title: "Reporte # 1", description: "Tu reporte ha sido aceptado", date: Date()),
                                Notification(type: .inReview, title: "Reporte # 3", description: "Tu reporte está siendo revisado", date: Date().addingTimeInterval(-86400)), // Ayer
                                Notification(type: .denied, title: "Reporte # 2", description: "Tu reporte fue denegado", date: Date().addingTimeInterval(-172800)) // Hace 2 días
                            ]
                        } else {
                            notifications = []
                        }
                        showEmptyState.toggle()
                    }) {
                        Image(systemName: showEmptyState ? "bell.fill" : "bell.slash.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                }
                .padding(.top)

                if showEmptyState {
                    EmptyNotificationsView()
                } else {
                    List {
                        ForEach(groupNotifications(notifications).keys.sorted(by: >), id: \.self) { date in
                            Section(header: Text(sectionHeader(for: date))
                                .font(.poppinsSemiBold(size: 18))
                                .foregroundColor(.white.opacity(0.8))) {
                                ForEach(groupNotifications(notifications)[date]!) { notification in
                                    NotificationRow(notification: notification)
                                }
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.9))
                    }
                    .listStyle(GroupedListStyle())
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                }
                Spacer()
            }.navigationBarBackButtonHidden(true)
        }
    }

    private func groupNotifications(_ notifications: [Notification]) -> [Date: [Notification]] {
        let grouped = Dictionary(grouping: notifications) { (notification) -> Date in
            return Calendar.current.startOfDay(for: notification.date)
        }
        return grouped
    }

    private func sectionHeader(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Hoy"
        } else if calendar.isDateInYesterday(date) {
            return "Ayer"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d 'de' MMMM"
            formatter.locale = Locale(identifier: "es_ES")
            return formatter.string(from: date)
        }
    }
}

struct NotificationRow: View {
    let notification: Notification

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: notification.type.icon)
                .font(.title)
                .foregroundColor(notification.type.iconColor)
                .frame(width: 40, height: 40)
                .background(notification.type.iconColor.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.poppinsSemiBold(size: 16))
                    .foregroundColor(Color(red: 0.0, green: 0.2, blue: 0.4))
                Text(notification.description)
                    .font(.poppinsRegular(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.vertical, 8)
    }
}

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
                .foregroundColor(.white.opacity(0.8))
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
