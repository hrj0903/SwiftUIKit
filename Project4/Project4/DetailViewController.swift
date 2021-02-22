//
//  DetailViewController.swift
//  Project4
//
//  Created by hrj on 2021/02/22.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = [String]()
    var webIndex = 0
    
    override func loadView() {
        webView = WKWebView()
        //"when any web page navigation happens, please tell me – the current view controller.”
        webView.navigationDelegate = self
        //we make our view (the root view of the view controller) that web view.
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [progressButton, spacer, backButton, forwardButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + websites[webIndex])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        // Do any additional setup after loading the view.
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        //guard let actionTitle = action.title else { return }
        //guard let url = URL(string: "https://" + actionTitle) else { return }
        //webView.load(URLRequest(url: url)
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    //As you can see it's telling us which key path was changed, and it also sends us back the context we registered earlier so you can check whether this callback is for you or not.
    override func observeValue(forKeyPath keyPath: String?, of: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //we set the constant url to be equal to the URL of the navigation. This is just to make the code clearer.
        let url = navigationAction.request.url
        
        // we use if let syntax to unwrap the value of the optional url.host. Remember I said that URL does a lot of work for you in parsing URLs properly? Well, here's a good example: this line says, "if there is a host for this URL, pull it out" – and by "host" it means "website domain" like apple.com. Note: we need to unwrap this carefully because not all URLs have hosts.
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            let accessUrl = UIAlertController(title: "This URL isn't allowed", message: "It's blocked", preferredStyle: .alert)
            accessUrl.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(accessUrl, animated: true)
        }
        
        decisionHandler(.cancel)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
