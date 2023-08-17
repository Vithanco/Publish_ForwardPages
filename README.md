# Publish_ForwardPages
Forward pages for the Publish static website framework

This plugin for [Publish](https://github.com/JohnSundell/Publish). Actually, it currently uses my fork at https://github.com/Vithanco/Publish, until John 
starts to maintain his again. 

## Installation

To install this plugin into your [Publish](https://github.com/johnsundell/publish) package, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        ...
        .package(
            url: "https://github.com/vithanco/Publish_ForwardPages.git",
            branch: "main")
    ],
    targets: [
        .target(
            ...
            dependencies: [
                ...
                "Publish_ForwardPages.git"
            ]
        )
    ]
    ...
)
```

And import to use it:

```swift
import Publish_ForwardPages.git
```

For more information on how to use the Swift Package Manager, check out [its official documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).

## Usage

You can use this to forward pages from one URL to another. 

```swift
let table = [
    // examples only
    Forward("starwars/lucasarts", "disney/starwars"),
    Forward("raider", "twix"),
    Forward("domain/IBIS", "notations/IBIS/index")
]

// ...

try mysite().publish(using: [
  // ...
    .generateSiteMap(indentedBy: nil), // normally there
    .installPlugin(.createForwardPages(table: table)),
  // ...
])
```

## License

MIT License
