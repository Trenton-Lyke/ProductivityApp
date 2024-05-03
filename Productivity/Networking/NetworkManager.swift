//
//  NetworkManager.swift
//  Productivity
//
//  Created by Trenton Lyke on 4/27/24.
//

import Alamofire
import Foundation

class NetworkManager {

    /// Shared singleton instance
    static let shared = NetworkManager()

    private init() { }

    /// Endpoint for dev server
    private let devEndpoint: String = "http://localhost:8000"
    
    func createUser(name: String, password: String, handler: @escaping (_ user: User?) -> (Void)) {
        let params: Parameters = [
            "name": name,
            "password": password
        ]
        AF.request("\(devEndpoint)/api/users/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil, interceptor: nil).response{ resp in
            switch resp.result{
                case .success(let data):
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let user: User = try decoder.decode(User.self, from: data!)
                        handler(user)
                    } catch {
                        handler(nil)
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    handler(nil)
                    print(error.localizedDescription)
            }
        }
    }
    
    func login(name: String, password: String, handler: @escaping (_ userSession: UserSessionData?) -> (Void)) {
        let params: Parameters = [
            "name": name,
            "password": password
        ]
        AF.request("\(devEndpoint)/api/users/login/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil, interceptor: nil).response{ resp in
            switch resp.result{
                case .success(let data):
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let userSession: UserSessionData = try decoder.decode(UserSessionData.self, from: data!)
                        handler(userSession)
                    } catch {
                        handler(nil)
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    handler(nil)
                    print(error.localizedDescription)
            }
        }
    }
    
    func logout(sessionToken: String, handler: @escaping (_ success: Bool) -> (Void)) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(sessionToken)"
        ]
        AF.request("\(devEndpoint)/api/users/login/", method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response{ resp in
            switch resp.result{
                case .success( _):
                    handler(true)
                    
                case .failure(let error):
                    handler(false)
                    print(error.localizedDescription)
            }
        }
    }

    
    func updateUser(sessionToken: String, handler: @escaping (_ apiData: UserSessionData?) -> (Void)) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(sessionToken)"
        ]
        AF.request("\(devEndpoint)/api/users/", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).response{ resp in
            switch resp.result{
                case .success(let data):
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let jsonData: UserSessionData = try decoder.decode(UserSessionData.self, from: data!)
                        handler(jsonData)
                    } catch {
                        handler(nil)
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    handler(nil)
                    print(error.localizedDescription)
            }
        }
    }
    
    func deleteCourse(sessionToken: String, courseId: Int, handler: @escaping (_ course: Course?) -> (Void)) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(sessionToken)"
        ]
        AF.request("\(devEndpoint)/api/course/\(courseId)/", method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response{ resp in
            switch resp.result{
                case .success(let data):
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let jsonData: Course = try decoder.decode(Course.self, from: data!)
                        handler(jsonData)
                    } catch {
                        handler(nil)
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    handler(nil)
                    print(error.localizedDescription)
            }
        }
    }
    
    func updateCourse(sessionToken: String, courseId: Int, name: String, code: String, description: String, handler: @escaping (_ course: Course?) -> (Void)) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(sessionToken)"
        ]
        let params: Parameters = [
            "name": name,
            "code": code,
            "description": description
        ]
        AF.request("\(devEndpoint)/api/course/\(courseId)/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response{ resp in
            switch resp.result{
                case .success(let data):
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let jsonData: Course = try decoder.decode(Course.self, from: data!)
                        handler(jsonData)
                    } catch {
                        handler(nil)
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    handler(nil)
                    print(error.localizedDescription)
            }
        }
    }
    
    func createCourse(sessionToken: String, name: String, code: String, description: String, handler: @escaping (_ course: Course?) -> (Void)) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(sessionToken)"
        ]
        let params: Parameters = [
            "name": name,
            "code": code,
            "description": description
        ]
        AF.request("\(devEndpoint)/api/course/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response{ resp in
            switch resp.result{
                case .success(let data):
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let jsonData: Course = try decoder.decode(Course.self, from: data!)
                        handler(jsonData)
                    } catch {
                        handler(nil)
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    handler(nil)
                    print(error.localizedDescription)
            }
        }
    }
    
    func createAssignment(sessionToken: String, courseId: Int, name: String, description: String, dueDate: Date, done: Bool, handler: @escaping (_ course: Assignment?) -> (Void)) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(sessionToken)"
        ]
        let params: Parameters = [
            "name": name,
            "description": description,
            "due_date": dueDate.timeIntervalSince1970,
            "done": done
        ]
        AF.request("\(devEndpoint)/api/courses/\(courseId)/assignment/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response{ resp in
            switch resp.result{
                case .success(let data):
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let jsonData: Assignment = try decoder.decode(Assignment.self, from: data!)
                        handler(jsonData)
                    } catch {
                        handler(nil)
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    handler(nil)
                    print(error.localizedDescription)
            }
        }
    }
    
//    func updateAssignment(sessionToken: String, courseId: Int, name: String, description: String, dueDate: Date, done: Bool, handler: @escaping (_ course: Assignment?) -> (Void)) {
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(sessionToken)"
//        ]
//        let params: Parameters = [
//            "name": name,
//            "description": description,
//            "due_date": dueDate.timeIntervalSince1970,
//            "done": done
//        ]
//        AF.request("\(devEndpoint)/api/courses/\(courseId)/assignment/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response{ resp in
//            switch resp.result{
//                case .success(let data):
//                    do{
//                        let decoder = JSONDecoder()
//                        decoder.dateDecodingStrategy = .secondsSince1970
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase
//                        let jsonData: Assignment = try decoder.decode(Assignment.self, from: data!)
//                        handler(jsonData)
//                    } catch {
//                        handler(nil)
//                        print(error.localizedDescription)
//                    }
//                case .failure(let error):
//                    handler(nil)
//                    print(error.localizedDescription)
//            }
//        }
//    }

    func createTimer(sessionToken: String, elapsedTime: Int, hours: Int, minutes: Int, seconds: Int, date: Date, handler: @escaping (_ course: TimerData?) -> (Void)) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(sessionToken)"
        ]
        let params: Parameters = [
            "elapsed_time": elapsedTime,
            "hours": hours,
            "minutes": minutes,
            "seconds": seconds,
            "date": date.timeIntervalSince1970
        ]
        AF.request("\(devEndpoint)/api/timer/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response{ resp in
            switch resp.result{
                case .success(let data):
                    do{
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let jsonData: TimerData = try decoder.decode(TimerData.self, from: data!)
                        handler(jsonData)
                    } catch {
                        handler(nil)
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    handler(nil)
                    print(error.localizedDescription)
            }
        }
    }
    
//    func getUserSubtasks(userId: Int, parentTaskId: Int, handler: @escaping (_ apiData: [Assignment]) -> (Void)) {
//        AF.request("\(devEndpoint)/api/tasks/\(userId)/subtasks/\(parentTaskId)/", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response{ resp in
//            switch resp.result{
//                case .success(let data):
//                    do{
//                        let decoder = JSONDecoder()
//                        decoder.dateDecodingStrategy = .secondsSince1970
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase
//                        let jsonData: [Assignment] = try decoder.decode([Assignment].self, from: data!)
//                        handler(jsonData)
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func createTask(taskParameters: CreateTaskParameters, handler: @escaping (_ Task: Assignment?) -> (Void)) {
//        let params: Parameters = [
//            "name": taskParameters.name,
//            "description": taskParameters.description,
//            "due_date": taskParameters.dueDate,
//            "done": taskParameters.done,
//            "is_subtask": taskParameters.isSubtask,
//            "parent_task_id": taskParameters.parentTaskId
//        ]
//        AF.request("\(devEndpoint)/api/tasks/", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil).response{ resp in
//            switch resp.result{
//                case .success(let data):
//                    do{
//                        let decoder = JSONDecoder()
//                        decoder.dateDecodingStrategy = .secondsSince1970
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase
//                        let Task: Assignment = try decoder.decode(Assignment.self, from: data!)
//                        handler(Task)
//                    } catch {
//                        handler(nil)
//                        print(error.localizedDescription)
//                    }
//                case .failure(let error):
//                    handler(nil)
//                    print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func completeTask(userId: String, taskId: String, handler: @escaping (_ success: Bool) -> (Void)) {
//        let params: Parameters = [
//            "user_id": userId,
//            "task_id": taskId
//        ]
//        AF.request("\(devEndpoint)/api/tasks/complete/", method: .post, parameters: params, encoding: URLEncoding.default, headers: nil, interceptor: nil).response{ resp in
//            switch resp.result{
//                case .success(let data):
//                    do{
//                        let decoder = JSONDecoder()
//                        decoder.dateDecodingStrategy = .secondsSince1970
//                        decoder.keyDecodingStrategy = .convertFromSnakeCase
//                        let _: Assignment = try decoder.decode(Assignment.self, from: data!)
//                        handler(true)
//                    } catch {
//                        handler(false)
//                        print(error.localizedDescription)
//                    }
//                case .failure(let error):
//                    handler(false)
//                    print(error.localizedDescription)
//            }
//        }
//    }
}
