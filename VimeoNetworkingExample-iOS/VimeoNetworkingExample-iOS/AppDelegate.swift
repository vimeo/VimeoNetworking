//
//  AppDelegate.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 3/17/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import VimeoNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        splitViewController.delegate = self
        let navigationController = splitViewController.viewControllers.last as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        
        // Starting the authentication process
        
        let authenticationController = AuthenticationController(client: VimeoClient.defaultClient)
        
        // First, we try to load a preexisting account
        
        let loadedAccount: VIMAccount?
        do
        {
            loadedAccount = try authenticationController.loadUserAccount()
        }
        catch let error
        {
            loadedAccount = nil
            print("error loading account \(error)")
        }
        
        // If we didn't find an account to load or loading failed, we'll authenticate using client credentials
        
        if loadedAccount == nil
        {
            authenticationController.clientCredentialsGrant { result in
                
                switch result
                {
                case .Success(let account):
                    print("authenticated successfully: \(account)")
                case .Failure(let error):
                    print("failure authenticating: \(error)")
                    
                    let title = "Client Credentials Authentication Failed"
                    let message = "Make sure that your client identifier and client secret are set correctly in VimeoClient+Shared.swift"
                    
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                    splitViewController.presentViewController(alert, animated: true, completion: nil)
                    print(title + ": " + message)
                }
            }
        }
        
        return true
    }
    
    // MARK: - URLs
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool
    {
        // This handles the redirect URL opened by Vimeo when you complete code grant authentication.
        // If your app isn't opening after you accept permissions on Vimeo, check that your app has the correct URL scheme registered.
        // See the README for more information.
        
        AuthenticationController(client: VimeoClient.defaultClient).codeGrant(responseURL: url) { result in
            
            switch result
            {
            case .Success(let account):
                print("authenticated successfully: \(account)")
            case .Failure(let error):
                print("failure authenticating: \(error)")
                
                let title = "Code Grant Authentication Failed"
                let message = "Make sure that your redirect URI is added to the dev portal"
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(action)
                self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                print(title + ": " + message)
            }
        }
        
        return true
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool
    {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}

