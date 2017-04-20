//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Яан Прокофьев on 11.04.17.
//  Copyright © 2017 Yaan Prokofiev. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    
    private let serviceType = "tinkoff-chat"
    fileprivate let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    private var sessionsByPeerIDKey = [MCPeerID:  MCSession]()
    
    let timeout = 30
    
    func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX)) + \(Date.timeIntervalSinceReferenceDate) + \(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    override init() {
        let discoveryInfo = ["userName": UIDevice.current.name]
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId,
                                                      discoveryInfo: discoveryInfo,
                                                      serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId,
                                                serviceType: serviceType)
        super.init()
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
     self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    
    func getPeerIDFor(userId: String) -> MCPeerID? {
        return sessionsByPeerIDKey.keys.filter {$0.displayName == userId}.first
    }
    
    func addSession(session: MCSession, peerId: MCPeerID) {
        session.delegate = self
        sessionsByPeerIDKey[peerId] = session
    }
    
    func getSessionFor(peer: MCPeerID) -> MCSession {
        if let session = sessionsByPeerIDKey[peer] {
            return session
        }
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessionsByPeerIDKey[peer] = session
        return session
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        print("sending message \(string) to \(userID)")
        let peerID = getPeerIDFor(userId: userID)
        if peerID == nil {
            return
        }
            do {
                let session = getSessionFor(peer: peerID!)
                try session.send(string.data(using: .utf8)!, toPeers: [peerID!],
                                      with: .reliable)
            } catch let error {
                print("Error occured while sending message \(error)")
            }
    }
    
    weak var delegate : CommunicatorDelegate?
    var online: Bool = false
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        let userID = peerID.displayName
        if (state == MCSessionState.connected) {
            self.delegate?.didFindUser(userID: userID, userName: "volodya")
        } else if (state == MCSessionState.notConnected) {
            self.delegate?.didLooseUser(userID: userID)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let message = String(data: data, encoding: .utf8)!
        NSLog("%@", "didReceiveData: \(message)")
        self.delegate?.didReceiveMessage(text: message, fromUser: peerID.displayName, toUser: myPeerId.displayName)
//        let str = String(data: data, encoding: .utf8)!
        // todo work with recieved data
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate{
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)");
        let session = getSessionFor(peer: peerID)
        invitationHandler(true, session)
    }
    
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer \(peerID)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer \(peerID)")
        NSLog("%@", "invitePeer \(peerID)")
        let session = getSessionFor(peer: peerID)
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: TimeInterval(self.timeout))
    }
}

