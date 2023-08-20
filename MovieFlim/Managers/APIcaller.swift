//
//  APIcaller.swift
//  MovieFlim
//
//  Created by MACBOOK on 14/08/2023.
//

import Foundation
struct Constants {
    static let API_KEY = "8e5e44f75c46681049c314e2fa3010ef"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyAb91Q-qM48lrzySyuc1-5u_LBUqzM_mzI"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
    //https://api.themoviedb.org/3/trending/all/day?api_key=8e5e44f75c46681049c314e2fa3010ef
}

enum APIError: Error {
    case failedToGetData
}
class APIcaller {
    static let shared = APIcaller()
    
    
    
    func getTrendingMovies(completion: @escaping (Result<[Movie],Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)")else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data , _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self,from: data)
                completion(.success(results.results))
            } catch {
                
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
        
        
        
    }
    func getTrendingTvs(completion: @escaping (Result<[Movie],Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)")else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data , _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self,from: data)
                
                completion(.success(results.results))
            } catch {
                
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    func getUpCommingMovie(completion: @escaping (Result<[Movie],Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
                let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    
                    do {
                        let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                        completion(.success(results.results))
                    } catch {
                        completion(.failure(APIError.failedToGetData))
                    }

                }
                task.resume()
    }
        
    
    func getPopular(completion: @escaping (Result<[Movie],Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
                let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    
                    do {
                        let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                        print(results)
                        completion(.success(results.results))
                        
                    } catch {
                        completion(.failure(APIError.failedToGetData))
                    }
                }
                
                task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void) {
            guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
            let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                
                do {
                    let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                    print(results)
                    completion(.success(results.results))

                } catch {
                    completion(.failure(APIError.failedToGetData))
                }

            }
            task.resume()
        }
    
    func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
           guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
           let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
               guard let data = data, error == nil else {
                   return
               }
               
               do {
                   let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                   completion(.success(results.results))

               } catch {
                   completion(.failure(APIError.failedToGetData))
               }

           }
           task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
           
           guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
           guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {
               return
           }
           
           let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
               guard let data = data, error == nil else {
                   return
               }
               
               do {
                   let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                   completion(.success(results.results))

               } catch {
                   completion(.failure(APIError.failedToGetData))
               }

           }
           task.resume()
       }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
           

           guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
           guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
           let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
               guard let data = data, error == nil else {
                   return
               }
               
               do {
                   let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                   print(results)
                   
                   completion(.success(results.items[0]))
                   

               } catch {
                   completion(.failure(error))
                   print(error.localizedDescription)
               }

           }
           task.resume()
       }
       
}
