//
//  UAPI.swift
//  Caricature_Swift
//
//  Created by 姚智豪 on 2019/10/16.
//  Copyright © 2019 姚智豪. All rights reserved.
//
/*
 MoYa：提供一些网络抽象层，它们经过充分地封装，并直接调用Alamofire。它们应该足够简单，可以很轻松地应对常见任务，也应该足够全面，应对复杂任务也同样容易，编译时检查正确的 API 端点访问。允许你使用枚举关联值定义不同端点的明确用法，将 test stub 视为一等公民，所以单元测试超级简单。
 
 MBProgressHUD:一个iOS插件类，当在后台线程进行工作时，它会显示一个带有指示器和/或标签的半透明HUD, 并且提供了多样的展示效果供我们使用
 */

import Moya
import HandyJSON
import MBProgressHUD

//NetworkActivityPlugin:管理网络状态的插件
let LoadingPlugin = NetworkActivityPlugin{ (type,target) in
    guard let vc = topVC else {return}
    switch(type){
        case .began:
            MBProgressHUD.hide(for: vc.view, animated: false)
            MBProgressHUD.showAdded(to: vc.view, animated: true)
        case .ended:
            MBProgressHUD.hide(for: vc.view, animated: true)
    }
}

enum UApi{
    case searchHot//搜索热门
    case searchRelative(inputText: String)//相关搜索
    case searchResult(argCon: Int, q: String)//搜索结果

    case boutiqueList(sexType: Int)//推荐列表
    case special(argCon: Int, page: Int)//专题
    case vipList//VIP列表
    case subscribeList//订阅列表
    case rankList//排行列表

    case cateList//分类列表

    case comicList(argCon: Int, argName: String, argValue: Int, page: Int)//漫画列表

    case guessLike//猜你喜欢

    case detailStatic(comicid: Int)//详情(基本)
    case detailRealtime(comicid: Int)//详情(实时)
    case commentList(object_id: Int, thread_id: Int, page: Int)//评论

    case chapter(chapter_id: Int)//章节内容
}

//Endpoint：用于将“目标”枚举的目标确定为具体端点的类
//RequestResultClosure：决定是否执行以及应执行什么请求的闭包。
let timeoutClosure = {(endpoint: Endpoint, closure: MoyaProvider<UApi>.RequestResultClosure)
    -> Void in
    if var urlRequest = try? endpoint.urlRequest() {
        urlRequest.timeoutInterval = 20
        closure(.success(urlRequest))
    }else{
        closure(.failure(MoyaError.requestMapping(endpoint.url)))
    }
    
}

extension UApi: TargetType{
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {return URL(string: "http://app.u17.com/v3/appV3_3/ios/phone")!}
    
    var path: String {
        switch self {
            case .searchHot: return "search/hotkeywordsnew"
            case .searchRelative: return "search/relative"
            case .searchResult: return "search/searchResult"
            
            case .boutiqueList: return "comic/boutiqueListNew"
            case .special: return "comic/special"
            case .vipList: return "list/vipList"
            case .subscribeList: return "list/newSubscribeList"
            case .rankList: return "rank/list"
            
            case .cateList: return "sort/mobileCateList"
            
            case .comicList: return "list/commonComicList"
            
            case .guessLike: return "comic/guessLike"
            
            case .detailStatic: return "comic/detail_static_new"
            case .detailRealtime: return "comic/detail_realtime"
            case .commentList: return "comment/list"
            
            case .chapter: return "comic/chapterNew"
        }
    }
    //網絡請求方式
    var method: Moya.Method {return .get}
    //表示一个HTTP任务
    var task: Task {
        var parameters: [String : Any] = [:]
        switch self {
        case .searchRelative(let inputText):
            parameters["inputText"] = inputText
        case .searchResult(let argCon, let q):
            parameters["argCon"] = argCon
            parameters["q"] = q
        case .boutiqueList(let sexType):
            parameters["sexType"] = sexType
        case .special(let argCon, let page):
            parameters["argCon"] = argCon
            parameters["page"] = max(1, page)
        case .comicList(let argCon, let argName, let argValue, let page):
            parameters["argCon"] = argCon
            if argName.count > 0 { parameters["argName"] = argName }
            parameters["argValue"] = argValue
            parameters["page"] = max(1, page)
        case .detailStatic(let comicid),
             .detailRealtime(let comicid):
            parameters["comicid"] = comicid
        case .commentList(let object_id, let thread_id, let page):
            parameters["object_id"] = object_id
            parameters["thread_id"] = thread_id
            parameters["page"] = page
        case .chapter(let chapter_id):
            parameters["chapter_id"] = chapter_id
        default:
            break
        }
        //URLEncoding.default在GET中是拼接地址的
        //requestParameters：一個請求體設置拼接參數的
        return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        let jsonString = String(data: data, encoding: .utf8)
        guard let model = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            //指示响应未能映射到JSON结构
            throw MoyaError.jsonMapping(self)
        }
        return model
    }
}

//MoyaProvider：请求提供程序类。 请求只能通过此类进行。
//discardableResult：取消 如果不使用返回值的警告
extension MoyaProvider{
    @discardableResult
    open func request<T: HandyJSON>(_ target: Target,
                                    model: T.Type,
                                    completion:((_ ReturnData: T?) -> Void)?)->
                                        Cancellable?{
                                            
        return request(target, completion: { (result) in
            guard let completion = completion else{return}
            guard let returnData = try? result.value?.mapModel(ResponseData<T>.self) else{
                completion(nil)
                return
            }
            completion(returnData.data?.returnData)
        })
    }
}
