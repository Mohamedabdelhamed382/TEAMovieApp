//
//  MoviesListViewController.swift
//  TEAMovieApp
//
//  Created by Mohamed abdelhamed on 10/08/2025.
//

import UIKit
import Combine

final class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: CollectionViewContentSized!
    
    private let viewModel: MoviesListViewModelProtocol
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: MoviesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Movies 2025"
        
        setupCollectionView()
        bindViewModel()
        viewModel.loadMovies(page: 1)
    }
    
    private func setupCollectionView() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        
        let nib = UINib(nibName: "MoviesListCollectionViewCell", bundle: nil)
        moviesCollectionView.register(nib, forCellWithReuseIdentifier: "MoviesListCollectionViewCell")
        
        moviesCollectionView.register(
            LoadingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.identifier
        )
    }
    
    private func bindViewModel() {
        viewModel.moviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                guard let self = self else { return }
                moviesCollectionView.reloadData()
            }
            .store(in: &cancellable)
        
        viewModel.errorMessagePublisher
            .sink { error in
                if let error = error {
                    print("Error:", error)
                }
            }
            .store(in: &cancellable)
    }
}

extension MoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesListCollectionViewCell", for: indexPath) as? MoviesListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.movies[indexPath.row], delegate: viewModel.delegateActionCell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 2) - 10
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.identifier,
                for: indexPath) as? LoadingFooterView else {
                return UICollectionReusableView()
            }

            if viewModel.isLoading {  // You'll need to expose this from your view model
                footer.startAnimating()
            } else {
                footer.stopAnimating()
            }
            return footer
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.isLoading ? CGSize(width: collectionView.frame.width, height: 50) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedMovie(index: indexPath.row)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            if offsetY > contentHeight - height - 100 {
                viewModel.loadNextPage()
            }
        }
}
