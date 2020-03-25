//
//  ChannelListViewModel.swift
//  YTDemoTask
//
//  Created by zeyad on 3/24/20.
//  Copyright © 2020 zeyad. All rights reserved.
//

import Foundation

class ChannelListViewModel {
    let apiService: APIServiceProtocol
    private var channels: [Channel] = [Channel]()
    private var cellViewModels: [ChannelCellViewModel] = [ChannelCellViewModel]() {
           didSet {
               self.reloadTableViewClosure?()
           }
       }
    
    // callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    

    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    func initFetch() {
        state = .loading
        apiService.fetchChannels { [weak self] (success, channels, error) in
            guard let self = self else {
                return
            }

            guard error == nil else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }

            self.processFetchedPhoto(channels: channels)
            self.state = .populated
        }
    }
    private func processFetchedPhoto(channels: [Channel] ) {
        self.channels = channels // Cache
        var vms = [ChannelCellViewModel]()
        for channel in channels {
            vms.append( createCellViewModel(channel:channel) )
        }
        self.cellViewModels = vms
    }
    func createCellViewModel(channel: Channel ) -> ChannelCellViewModel {
        
        let title = channel.items[0].snippet.title
        let thumbnil = channel.items[0].snippet.thumbnails.thumbnailsDefault.url
        return ChannelCellViewModel(titleText: title, thumbnilUrl: thumbnil)
    }
    func getCellViewModel( at indexPath: IndexPath ) -> ChannelCellViewModel {
        return cellViewModels[indexPath.row]
    }
}
