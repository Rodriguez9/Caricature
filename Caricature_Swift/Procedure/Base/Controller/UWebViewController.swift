//
//  UWebViewController.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/9/16.
//  Copyright © 2019 姚智豪. All rights reserved.
//

import UIKit
import WebKit

class UWebViewController: UBaseViewController {

    var request: URLRequest!
    
    //懶加載webView，並設置屬性
    //.allowsBackForwardNavigationGestures:一个布尔值，指示水平滑动手势是否会触发后退列表导航
    //.navigationDelegate:WebView的导航委托
    //.uiDelegate:WebView的用户界面委托
    lazy var webView: WKWebView = {
        let ww = WKWebView()
        ww.allowsBackForwardNavigationGestures = true
        ww.navigationDelegate = self
        ww.uiDelegate = self
        return ww
    }()
    
    //.trackImage:用于未填充的轨道部分的图像
    //.progressTintColor:显示填充进度条部分的颜色
    lazy var progressView: UIProgressView = {
        let pw = UIProgressView()
        pw.trackImage = UIImage.init(named: "nav_bg")
        pw.progressTintColor = UIColor.white
        return pw
    }()
    
    convenience init(url: String?){
        self.init()
        self.request = URLRequest(url: URL(string: url ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(request)
    }
    
    override func configUI() {
        
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"),
                                                            target: self,
                                                            action: #selector(reload))
    }
    
    @objc func reload(){
        webView.reload()
    }
    
    override func pressBack() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

}

extension UWebViewController: WKNavigationDelegate,WKUIDelegate{
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress >= 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        navigationItem.title = title ?? (webView.title ?? webView.url?.host)
    }
    
}
