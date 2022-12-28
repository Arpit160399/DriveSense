//
//  CreateInstructorModelUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 19/09/22.
//
import Combine
import Foundation

class CacheInstructorModel: InstructorCaching {
    
    private var task = Set<AnyCancellable>()
    private let localStore: InstructorPersistenceLayer
    private weak var delegate: (any CachingCompletionHandler)?
    
    init(localStore: InstructorPersistenceLayer,
         delegate: any CachingCompletionHandler) {
        self.localStore = localStore
        self.delegate = delegate
    }
    
    
    
    func saveInstructor(model: InstructorModel)  {
        guard let adiNo = model.adi?.no else {return}
        Task {
            do {
                guard  try await find(adiNo: adiNo) != nil else {
                    createInstructor(model: model)
                    return
                }
                updateInstructor(model: model)
            } catch {
                // TODO :- handle error
                delegate?.cachingFinished(withError: error)
            }
        }
    }
    
    fileprivate func updateInstructor(model: InstructorModel) {
        localStore.update(instructor: model)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.delegate?.cachingFinished(withError: error)
                }
            } receiveValue: { model in
                self.delegate?.cachingFinished(res: model)
            }.store(in: &task)
    }
    
    fileprivate func createInstructor(model: InstructorModel) {
        localStore.create(instructor: model)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.delegate?.cachingFinished(withError: error)
                }
            } receiveValue: { model in
                self.delegate?.cachingFinished(res: model)
            }.store(in: &task)
    }
    
    fileprivate func find(adiNo: String) async throws -> InstructorModel? {
        try await withCheckedThrowingContinuation({ continuation in
            localStore.find(predicated: .init(format: "adi.no == %@",adiNo))
               .sink { completion in
                   if case .failure(let error) = completion {
                       continuation.resume(throwing: error)
                   }
               } receiveValue: { model in
                   continuation.resume(with: .success(model.first))
            }.store(in: &task)
        })
    }
    
    func removeInstructor(model: InstructorModel) {
        localStore.remove(instructor: model)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.delegate?.cachingFinished(withError: error)
                }
            } receiveValue: {
                self.delegate?.cachingFinished(res: model)
            }.store(in: &task)
    }
    
}
