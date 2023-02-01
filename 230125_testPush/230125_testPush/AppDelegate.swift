//
//  AppDelegate.swift
//  230125_testPush
//
//  Created by estech on 25/1/23.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Pedir permiso al usuario para notificaciones push
        registerForPushNotifications()
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.banner)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func registerForPushNotifications() {
        //Pedir permiso al usuario para recibir notificaciones push
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permiso concedido: \(granted)")
            
            guard granted else { return } //Nos aseguramos de que granted == true
            
            self.getNotificationSettings()
        }
        
        //define las acciones personalizadas
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", title: "Aceptar", options: [.foreground])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION", title: "Rechazar", options: [.foreground])
        
        //Define el tipo de notificación
        let meetingInviteCategory = UNNotificationCategory(identifier: "MEETING_INVITATION", actions: [acceptAction, declineAction], intentIdentifiers: [], options: .customDismissAction)
        
        //Registrar el tipo de notificación
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
        
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            print("Configuración push: \(settings)")
            //Comprobamos que el usuario nos ha autorizado a enviarle notificaciones push
            guard settings.authorizationStatus == .authorized else { return }
            
            //Registrarlo en APNs
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    //Si se ha completado el registro
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        print("Device token: \(token)")
    }
    
    //Si se produce un error al tratar de registrar el dispositivo
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //Obtener el meetID de la notificación (fuera de aps)
        let userInfo = response.notification.request.content.userInfo
        let meetID = userInfo["MEETING_ID"] as! String
        
        if let aps = userInfo["aps"] as? [String:AnyObject] {
            //Realizar la tarea correspondiente a la acción
            switch response.actionIdentifier {
            case "ACCEPT_ACTION":
                //El usuario ha aceptado la acción
                break
            case "DECLINE_ACTION":
                //El usuario ha rechazado la acción
                break
            default:
                break
            }
            completionHandler()
        }
        
        
//        guard let aps = userInfo["aps"] as? [String:AnyObject] else {
//            completionHandler(.failed)
//            return
//        }
//
//
//        guard let alert = aps["alert"] as? [String:String] else {
//            return
//        }
//
//        print(alert["title"])
//
//
//
//        guard let notif = userInfo as? [String:AnyObject] else {
//            completionHandler(.failed)
//            return
//        }
//
//        print(notif)
        
        
        //Mostrar la notificación en un alert
//        var alertController = UIAlertController(title: aps["alert"]?["title"] as! String, message: aps["alert"]?["body"] as! String, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "ok", style: .default))
//
//        self.window?.rootViewController?.present(alertController, animated: true)
        
        
        //Modificar el badge
//        if let pushBadgeNumber: Int = aps["badge"] as? Int {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "BadgeChanged"), object: nil)
//            UIApplication.shared.applicationIconBadgeNumber = pushBadgeNumber
//        }
        
    }

}
