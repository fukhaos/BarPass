//
//  Api.swift
//  guroo
//
//  Created by Bruno Lopes de Mello on 07/05/19.
//  Copyright © 2019 Bruno Lopes de Mello. All rights reserved.
//

import Foundation
import Alamofire

#if RELEASE
let debugRequests = false
#else
let debugRequests = true
#endif

// POST /api/v1/File/Upload
struct ResultUploadImage : Codable {
    var data : UploadImageData!
}
struct UploadImageData : Codable {
    var fileName : String!
}

class Api {
    
    let alamofireManager = Alamofire.SessionManager.default
    
    static let downloadManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3 * 60
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    func isInternetConnection() -> Bool {
        return true
    }
    
    /// Requisição simples
    ///
    /// - Parameters:
    ///   - metodo: tipo de requisição (get ou post)
    ///   - tipo: metodo em que vai ser chamado
    ///   - parametros: parametros da requisição
    ///   - onSuccess: clausura de sucesso
    ///   - onFail: clausura de erro
    func request(metodo: wMethods,
                 url: String? = nil,
                 parametros: [String: Any],
                 onSuccess: @escaping (_ response: HTTPURLResponse, _ objeto: Any) -> Void,
                 onFail: @escaping (_ response: HTTPURLResponse?, _ erroDescription: String) -> Void) {
        
        var tipoRequisicao: HTTPMethod?
        var urlRequisicao = ""
        
        if !Utils.isConnectedToNetwork() {
            onFail(nil, "Verifique sua conexão com a internet e tente novamente")
            return
        }
        
//        let user = UserInfoHandler.fetchUser()
//        let status = OneSignal.getPermissionSubscriptionState()
        
        switch metodo {
        case .wGET:
            tipoRequisicao = .get
        case .wPOST:
            tipoRequisicao = .post
        }
        
        if debugRequests && metodo == .wPOST {
            print("\n\n===========JSON===========")
            parametros.printJson()
            print("===========================\n\n")
        }
        
        if let url = url {
            urlRequisicao = url
        } else {
            print("Ocorreu um erro, nenhum método padrão esta definido e nenhuma url personalizada esta definida")
        }
        
        alamofireManager.request(urlRequisicao,
                                 method: tipoRequisicao!,
                                 parameters: parametros).debugLog().responseJSON { response in
                                    
                                    if debugRequests {
                                        print("""
                                            \nDevice ID: \(UIDevice.current.identifierForVendor!.uuidString)
                                            \n\nRequest: \(String(describing: response.request))
                                            \nParametros: \n\(parametros)
                                            \nTipo requisição:\(tipoRequisicao ?? .get)\n\n
                                            """)
                                        print(response)
                                    }
                                    
                                    switch response.result {
                                    case .success:
                                        
                                        if let respostaServidor = response.result.value {
                                            onSuccess(response.response!, respostaServidor)
                                        } else {
                                            print("\n\n===========Error===========")
                                            print("Error Code: \(response.error?._code ?? 0)")
                                            print("Error Messsage: \(response.error?.localizedDescription ?? "UNKNOW ERROR")")
                                            if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                                                print("Server Error: " + str)
                                            }
                                            debugPrint(response.error as Any)
                                            print("===========================\n\n")
                                            onFail(response.response, "Sem resposta do servidor no momento (cod.80).")
                                        }
                                        
                                    case .failure(let error):
                                        
                                        //                                        let mensagemErro = error.localizedDescription
                                        //                                        onFail(response.response, mensagemErro)
                                        print("\n\n===========Error===========")
                                        print("Error Code: \(error._code)")
                                        print("Error Messsage: \(error.localizedDescription)")
                                        if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                                            print("Server Error: " + str)
                                        }
                                        debugPrint(error as Any)
                                        print("===========================\n\n")
                                        onFail(response.response, "Sem resposta do servidor no momento (cod.80).")
                                        
                                    }
        }
    }
    
    public func requestCodable<T>(metodo: wMethods,
                                  url: String? = nil,
                                  objeto: T.Type,
                                  parametros: [String: Any],
                                  token: String = "",
                                  onSuccess: @escaping (_ response: HTTPURLResponse, _ objeto: T) -> Void,
                                  onFail: @escaping (_ response: HTTPURLResponse?, _ erroDescription: String) -> Void)
        where T: Codable {
            
            if !Utils.isConnectedToNetwork() {
                onFail(nil, "Verifique sua conexão com a internet e tente novamente")
                return
            }
            
            let accessToken = RealmUtils().getToken().accessToken
            
            let tipoRequisicao = getTipoRequisicao(tipo: metodo)
//            let status = OneSignal.getPermissionSubscriptionState()
            var urlRequisicao = ""
            
            if debugRequests && metodo == .wPOST {
                print("\n\n===========JSON===========")
                parametros.printJson()
                print("===========================\n\n")
            }
            
            if let url = url {
                urlRequisicao = url
            } else {
                print("Ocorreu um erro, nenhum método padrão esta definido e nenhuma url personalizada esta definida")
            }
            
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \((accessToken) ?? "" )"
            ]
            
            var encoded: ParameterEncoding = JSONEncoding.default
            
            if tipoRequisicao == .get {
                encoded = URLEncoding.default
            }
            
            Alamofire.request(urlRequisicao,
                              method: tipoRequisicao,
                              parameters: parametros, encoding: encoded, headers: headers).debugLog()
                .responseJSON { (response) in
                    
                    if debugRequests {
                        print("""
                            \nDevice ID: \(UIDevice.current.identifierForVendor!.uuidString)
                            \n\nRequest: \(String(describing: response.request))
                            \nParametros: \n\(parametros)
                            \nTipo requisição:\(tipoRequisicao)\n\n
                            """)
                        print(response)
                    }
                    
                    if response.response?.statusCode == 401 {
                        self.getToken(completed: {
                            //Forces a reconnection while i don`t find a way to re-call
                            onFail(nil, "Não foi possível completar a operação, tente novamente!")
                        }, onFail: { (msg) in
                            onFail(nil, msg)
                        })
                        return
                    }
                    
                    switch response.result {
                        
                    case .success:
                        //                                    let decoder = JSONDecoder()
                        //                                    decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                        
                        do {
                            let objeto = try JSONDecoder().decode(objeto.self, from: response.data!)
                            onSuccess(response.response!, objeto)
                        } catch (let error) {
                            print("\n\n===========Error===========")
                            print("Error Code: \(error._code)")
                            print("Error Messsage: \(error.localizedDescription)")
                            if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                                print("Server Error: " + str)
                            }
                            debugPrint(error as Any)
                            print("===========================\n\n")
                        }
                        
                        //                                    if let objeto = try? decoder.decode(objeto.self, from: response.data!) {
                        //                                        onSuccess(response.response!, objeto)
                        //                                    } else {
                        //                                        onFail(response.response!, "Sem resposta do servidor no momento (cod.80). Tente novamente")
                        //                                    }
                        
                    case .failure(let error):
                        print("\n\n===========Error===========")
                        print("Error Code: \(error._code)")
                        print("Error Messsage: \(error.localizedDescription)")
                        if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }
                        debugPrint(error as Any)
                        print("===========================\n\n")
                        onFail(response.response, "Sem resposta do servidor no momento (cod.80).")
                    }
            }
            
            
    }
    
    public func downloadFile(source: URL,
                             nomeArquivo: String = "",
                             salvar: Bool = false,
                             progressCompletion: ((Float) -> Void)? = nil,
                             completion: @escaping (_ response: DefaultDownloadResponse, _ path: URL?) -> Void) {
        
        var fileName = source.lastPathComponent
        if !nomeArquivo.isEmpty {
            fileName = nomeArquivo
        }
        if debugRequests {
            print("\n\nRequest: \(source.relativeString)")
        }
        
        //download
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsDirectoryURL = try? FileManager()
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: salvar)
            documentsDirectoryURL?.appendPathComponent(fileName)
            guard let fileURL = documentsDirectoryURL else { return (URL(fileURLWithPath: ""), []) }
            if !salvar {
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            } else {
                return (fileURL, [])
            }
        }
        
        Api.downloadManager
            .download(source.relativeString, to: destination).downloadProgress { (progress) in
                let percent = Float(progress.fractionCompleted)
                if let passProgress = progressCompletion {
                    passProgress(percent)
                }
            }.response { response in
                completion(response, response.destinationURL)
        }
        
    }
    
    private func getTipoRequisicao(tipo: wMethods) -> HTTPMethod {
        switch tipo {
        case .wGET:
            return .get
        case .wPOST:
            return .post
        }
    }
    
    public func uploadImage(_ image: UIImage, onSuccess: @escaping (UploadImageData?) -> Void, onFailure: @escaping (Error) -> Void ) {
        
//        let status = OneSignal.getPermissionSubscriptionState()
        let accessToken = RealmUtils().getToken().accessToken
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer \(accessToken ?? "")"
            ]
        
        let imgData = image.jpeg(.high)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData ?? Data(), withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
        },
                         to:"\(URLs.apiEndPoint)/File/Upload",
            method: .post,
            headers: headers) { result in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
                        
                        if debugRequests {
                            print("""
                                \nDevice ID: \(UIDevice.current.identifierForVendor!.uuidString)
                                \n\nRequest: \(String(describing: response.request))
                                \nTipo requisição: POST\n\n
                                """)
                            print(response)
                        }
                        
                        
                        let statusCode = response.response?.statusCode
                        print("statusCode: \(String(describing: statusCode))")
                        
                        if response.result.isSuccess {
                            do {
                                let json = try JSONDecoder().decode(ResultUploadImage.self, from: response.data!)
                                if let fileJson = json.data {
                                    onSuccess(fileJson)
                                } else {
                                    onSuccess(nil)
                                }
                            } catch (let error) {
                                print("\n\n===========Error===========")
                                print("Error Code: \(error._code)")
                                print("Error Messsage: \(error.localizedDescription)")
                                if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                                    print("Server Error: " + str)
                                }
                                debugPrint(error as Any)
                                print("===========================\n\n")
                                onFailure(error)
                            }
                        }
                    }
                    
                case .failure(let error):
                    print("\n\n===========Error===========")
                    print("Error Code: \(error._code)")
                    print("Error Messsage: \(error.localizedDescription)")
                    debugPrint(error as Any)
                    print("===========================\n\n")
                    onFailure(error)
                }
                
        }
        
    }
    
    // TODO: Update post resquest to RequestManager method
    public func getToken(completed: @escaping () -> Void,
                         onFail: @escaping (_ msg: String) -> Void) {
        
        let refreshToken = RealmUtils().getToken().refreshToken
        
        let params: [String: Any] = [
            "refreshToken": refreshToken ?? ""
        ]

            Alamofire.request(URLs.signin, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in

                print("Megaleios - statusCode: \(String(describing: response.response?.statusCode))")

                if let statusCode = response.response?.statusCode {
                    if statusCode == 400 {
                        onFail("")
                        return
                    }
                }

                if response.data != nil {
                    do {
                        let objeto = try JSONDecoder().decode(RegisterReturn.self, from: response.data!)
                        RealmUtils().save(objeto.data!,
                                          onComplete: {
                                            completed()
                        }, onError: { (msg) in
                            onFail(msg)
                        })
                    } catch (let error) {
                        print("\n\n===========Error===========")
                        print("Error Code: \(error._code)")
                        print("Error Messsage: \(error.localizedDescription)")
                        if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                            print("Server Error: " + str)
                        }
                        debugPrint(error as Any)
                        print("===========================\n\n")
                    }
                }
            }

        }
}

