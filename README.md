### About the project

The project is using Carthage, I've included the compiled binaries in the package (without the full project checkout made by Carthage) so you might not need to run it. In case you need, it is a simple `carthage bootstrap --no-use-binaries --platform iOS`.

The workspace has 2 projects:

* `AppServices` - A framework responsible to call the API endpoints.
* `App` - The target to run the app.

I have divided into two projects with the idea of a modularized architecture, something I've been exploring more and more in recent projects. The `AppServices` framework exposes only the class to make the call to the API and the needed models.

In `App`, I included a protocol called `ReusableCell` to make it easier to register and reuse cells. It is a protocol I've put together from my ideas and from Swift articles on the web and I am using in personal projects.

`UIViewExtension` has a syntactic sugar for autolayout. I chose to build my own than using another library.

The list of reviews is an infinite loading list, that load the next page (offset) when you are reaching the end of it. For simplicity, I am not handling the case of reaching the last offset of reviews.

## 3rd party libraries and images

The only included external library is `RxSwift`, that I am using the traits to make the API requests and pass it forward.

The icons are free and public available images from [Flaticon](https://www.flaticon.com/).

## What I would change/improve

* The UITableView data source and delegate is being handled by `ReviewsListViewController`, it may be better to create a separate class (something like `ListDataSource`) to handle it in a more generic approach.

* Use `Combine` as a replacement for `RxSwift`
