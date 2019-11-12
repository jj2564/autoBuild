//
//  SSOConnect.swift
//  autoBuild
//
//  Created by IrvingHuang on 2019/9/20.
//  Copyright © 2019 Irving Huang. All rights reserved.
//

import AuthenticationServices
import SafariServices

public final class WebAuthenticationSession {
    
    public enum Error: Swift.Error {
        case canceledLogin
    }
    
    private enum Session {
        @available(iOS 12.0, *)
        case asWebAuthenticationSession(ASWebAuthenticationSession)
        case sfAuthenticationSession(SFAuthenticationSession)
    }
    
    private let session: Session
    
    /**
     Returns a WebAuthenticationSession object.
     
     - Parameter url: The initial URL pointing to the authentication webpage. Only supports URLs with http:// or https:// schemes.
     - Parameter callbackURLScheme: The custom URL scheme that the app expects in the callback URL.
     - Parameter completionHandler: The completion handler which is called when the session is completed successfully or canceled by user.
     - Parameter responseURL: The URL returned once authentication has succeeded or failed.
     - Parameter error: The error if WebAuthenticationSession was unable to authenticate.
     */
    public init(url: URL, callbackURLScheme: String?, completionHandler handler: @escaping (_ responseURL: URL?, _ error: Swift.Error?) -> ()) {
        let completionHandler = { (url: URL?, error: Swift.Error?) in
            if #available(iOS 12.0, *), case ASWebAuthenticationSessionError.canceledLogin? = error {
                handler(url, Error.canceledLogin)
            } else if case SFAuthenticationError.canceledLogin? = error {
                handler(url, Error.canceledLogin)
            } else {
                handler(url, error)
            }
        }
        
        if #available(iOS 12.0, *) {
            self.session = .asWebAuthenticationSession(ASWebAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler))
        } else {
            self.session = .sfAuthenticationSession(SFAuthenticationSession(url: url, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler))
        }
    }
    
    /**
     Starts the WebAuthenticationSession instance after it is instantiated.
     
     Start can only be called once for an WebAuthenticationSession instance. This also means calling start on a canceled session will fail.
     
     - Returns: Returns `true` if the session starts successfully.
     */
    @discardableResult public func start() -> Bool {
        switch session {
        case let .asWebAuthenticationSession(session):
            return session.start()
        case let .sfAuthenticationSession(session):
            return session.start()
        }
    }
    
    /**
     Cancel a WebAuthenticationSession. If the view controller is already presented to load the webpage for authentication, it will be dismissed. Calling cancel on an already canceled session will have no effect.
     */
    public func cancel() {
        switch session {
        case let .asWebAuthenticationSession(session):
            session.cancel()
        case let .sfAuthenticationSession(session):
            session.cancel()
        }
    }
    
}
