//
//  SectionHeaderView.swift
//  Zebra
//
//  Created by Adam Demasi on 4/3/2022.
//  Copyright © 2022 Zebra Team. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {

	var title: String? {
		get { label.text }
		set { label.text = newValue }
	}

	var buttons: [SectionHeaderButton] = [] {
		didSet { updateButtons() }
	}

	private var label: UILabel!
	private var buttonsStackView: UIStackView!

	override init(frame: CGRect) {
		super.init(frame: frame)

		let effectView = UIToolbar()
		effectView.translatesAutoresizingMaskIntoConstraints = false
		effectView.delegate = self
		addSubview(effectView)

		label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .headline)
		label.textColor = .label

		buttonsStackView = UIStackView()
		buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
		buttonsStackView.spacing = 4

		let stackView = UIStackView(arrangedSubviews: [label, UIView(), buttonsStackView])
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.spacing = 15
		stackView.alignment = .center
		addSubview(stackView)

		NSLayoutConstraint.activate([
			effectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			effectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			effectView.topAnchor.constraint(equalTo: self.topAnchor),
			effectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

			stackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
			stackView.topAnchor.constraint(equalTo: readableContentGuide.topAnchor),
			stackView.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor),
		])
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func updateButtons() {
		for item in buttonsStackView.arrangedSubviews {
			item.removeFromSuperview()
			buttonsStackView.removeArrangedSubview(item)
		}
		for item in buttons {
			buttonsStackView.addSubview(item)
			buttonsStackView.addArrangedSubview(item)
		}
	}

}

extension SectionHeaderView: UIToolbarDelegate {
	func position(for bar: UIBarPositioning) -> UIBarPosition {
		.top
	}
}

extension NSCollectionLayoutBoundarySupplementaryItem {
	static var header: NSCollectionLayoutBoundarySupplementaryItem {
		let item = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
																																															heightDimension: .absolute(52)),
																													 elementKind: "Header",
																													 alignment: .top)
		item.pinToVisibleBounds = true
		item.zIndex = .max
		return item
	}
}
