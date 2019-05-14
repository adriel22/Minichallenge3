//
//  ViewController.swift
//  Minichallenge3
//
//  Created by Adriel Freire on 06/05/19.
//  Copyright © 2019 Adriel Freire. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let str1 = "Jurema é uma jovem moça a qual, talvez, quem sabe, maybe, entende muito do que acontece "
            let str2 = "na corriqueira vida dos outros, talento esse que também é conhecido como o tal do fofoqueirismo"
            let str = "\(str1)\(str2)"
            
            let str3 = "Certo dia, Jurema descobriu uma fofoca super intrigante. Porém, contudo, todavia, entretanto, "
            let str4 = "ela está receosa em contá-la para sua mais que amiga, sua friend, Marivalda. E aí você contaria?"
            let branchResume = "\(str3)\(str4)"
            
            let story = HistoryNode(withResume: str, andText: str)
            let secNode = HistoryNode(withResume: branchResume, andText: branchResume)
            let connection = HistoryConnection(destinyNode: secNode, title: "O grande babado")
            story.connections.append(connection)
            story.connections.append(connection)
            story.connections.append(connection)
            story.connections.append(connection)
            story.connections.append(connection)
            
            let controller = DetailsViewController()
            let navigationController = UINavigationController(rootViewController: controller)
            self.present(navigationController, animated: true, completion: {
                controller.viewModel = DetailsViewModel(story: story)
            })
        }
    }

}
