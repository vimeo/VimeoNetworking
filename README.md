⚠️⚠️⚠️ This library has been deprecated and will be removed in the future. ⚠️⚠️⚠️

# VimeoNetworking [![](https://circleci.com/gh/vimeo/VimeoNetworking.png?style=shield&circle-token=0443de366b231f05e3b1b1b3bf64a434b9ec1cfe)](https://circleci.com/gh/vimeo/VimeoNetworking)

**VimeoNetworking** is the authoritative Swift networking library for the Vimeo API.  Fully designed and implemented with Swift in mind, **VimeoNetworking** is type-safe, well `enum`erated, and never, ever, *ever* force-unwrapped.

##### Hey Creator, if you're primarily interested in uploading videos to Vimeo, you should also check out [VimeoUpload](https://github.com/vimeo/VimeoUpload).

## Supported Platforms

- iOS (8.0+)
- tvOS (9.0+)

## Installing

### Cocoapods

To get started add the following to your Podfile:

```Ruby
use_frameworks!

target 'YourTarget' do
    pod 'VimeoNetworking'
end
```

### Carthage

Add the following to your Cartfile:

```
github "vimeo/VimeoNetworking"
```

You can optionally specify a version number, or point directly to our `develop` branch. Note that breaking changes may be introduced into `develop` at any time, but those changes will always be behind a major or minor release version number.

## Initialization

The first step towards using the Vimeo API is registering a new application on the Vimeo Developer site: [My API Apps](https://developer.vimeo.com/apps).  You'll need a Vimeo account, if you don't already have one.

### App Configuration

Once you have a new app set up, click into its authentication settings and make note of the "Client Identifier" and "Client Secret" fields.  Next, determine which `Scope` permissions your application requires from the available options listed here: [Supported Scopes](https://developer.vimeo.com/api/authentication#scopes).  Use this information to instantiate a new `AppConfiguration` value:

```Swift
let appConfiguration = AppConfiguration(
		clientIdentifier: "Your client identifier goes here",
		clientSecret: "Your client secret goes here",
		scope: [.Public, .Private, .Interact] //replace with your scopes)
```

### Client

To interact with the Vimeo API, we use a `VimeoClient` instance.  The client is the primary interface of **VimeoNetworking**, it takes care of executing requests, cache storage and retrieval, tracking the current authenticated account, and handling global error conditions.  You can instantiate one with the application configuration you created a moment ago.

```Swift
let vimeoClient = VimeoClient(configuration: appConfiguration)
```

## Authenticating

Before we can actually start getting meaningful data from the API, there's one last step: authentication. `AuthenticationController` handles and simplifies this process.  It uses the configuration of an associated `VimeoClient` to make requests. On successful authentication, it passes the new Vimeo account back to this client, and that client can then make requests to API endpoints.  There are two ways to authenticate: *Client Credentials grant* and *Code grant*, detailed below:

### Client Credentials

Client credentials allow you to see everything that's publicly available on Vimeo.  This is essentially equivalent to visiting Vimeo.com without signing up for an account or logging in.  This is the simplest authentication method to implement, just one function completes the grant.

```Swift
let authenticationController = AuthenticationController(client: vimeoClient)

authenticationController.clientCredentialsGrant { result in
	switch result {
	case .Success(let account):
		print("Successfully authenticated with account: \(account)")
	case .Failure(let error):
		print("error authenticating: \(error)")
	}
}
```

### Code Grant

If you want to log in as a user, the Vimeo API provides a process called Code Grant authentication.  This is a bit more involved than a client credentials grant, but it gives your application the benefit of making requests on behalf of a Vimeo user, and viewing their personal content.  

To authenticate via code grant, your app launches a specific URL in Safari.  The user signs up or logs in on Vimeo.com, and chooses which permissions to grant.  Then, control is redirected back to your application where authentication completes.

To prepare your application to receive this redirect, navigate to your app's target's settings > Info > URL Types.  Add a new URL Type, and under url scheme enter `vimeo` followed by your client identifier (for example, if your client identifier is `1234`, enter `vimeo1234`).  You also need to add this redirect URL to your app on the [Vimeo API](https://developer.vimeo.com/apps) site.  Under “App Callback URL”, add `vimeo{CLIENT_IDENTIFIER}://auth` (for the example above, `vimeo1234://auth`).

Now, in an appropriate place in your app, open the code grant authorization URL in Safari:

```Swift
let authenticationController = AuthenticationController(client: vimeoClient)

let URL = authenticationController.codeGrantAuthorizationURL()
UIApplication.sharedApplication.openURL(URL)
```

The user will be prompted to log in and grant permissions to your application.  When they accept, your redirect URL will be opened, which will reopen your application.  Handle this event in your application delegate:

```Swift
func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool
    {
        authenticationController.codeGrant(responseURL: url) { result in
            switch result
            {
            case .Success(let account):
                print("authenticated successfully: \(account)")
            case .Failure(let error):
                print("failure authenticating: \(error)")
            }
        }

        return true
    }
```

### Lightweight Use

If you want to use your own OAuth token, for example a contant token generated for your [API's application](https://developer.vimeo.com/apps), you can circumvent code grant authorization mechanisms and use the ```accessToken``` function of ```AuthenticationController```.

```Swift
let authenticationController = AuthenticationController(client: vimeoClient)
authenticationController.accessToken("your_access_tocken") { result in
    switch result
    {
        case .Success(let account):
            print("authenticated successfully: \(account)")
        case .Failure(let error):
           print("failure authenticating: \(error)")
    }
}
```

### Saved Accounts

`AuthenticationController` saves the accounts it successfully authenticates in the Keychain.  The next time your application launches, you should first attempt to load a previously authenticated account before prompting the user to authenticate.

```Swift
do
{
	if let account = try authenticationController.loadSavedAccount()
	{
		print("account loaded successfully: \(account)"
	}
	else
	{
		print("no saved account found, authenticate...")
	}
}
catch let error
{
	print("error loading account: \(error)")
}
```

## Interacting with Vimeo

You're initialized, you're configured, you're authenticated.  Now you're ready to rock!  Let's start hitting some endpoints. 🤘

### Constructing Requests

We represent each interaction with the Vimeo API as an instance of `Request`.  Each one holds its own understanding of HTTP method, URL path, parameters (if any), expected model object type, caching behavior, and (if desired) retry-after-failure behavior.  That's a lot to grasp up front, so let's step back and look at the simplest request we can make, a single video:

```Swift
let videoRequest = Request<VIMVideo>(path: "/videos/45196609")
```

There are two critical takeaways here:
- `<VIMVideo>`: the generic type of the model object.  This is what the request will return in the `Response` if it's successful.
- `path: "..."`: the API endpoint we want to call, you can see a whole host of other options at [Vimeo API Endpoints](https://developer.vimeo.com/api/endpoints)

By declaring the expected model object type, we can ensure that both the request and the parsing of the JSON is successful, and we can guarantee that our `Response` precisely matches this expectation.  All potential Vimeo models are already implemented in **VimeoNetworking**, and they're available for use in your own implementation.  Model classes are all named with the `VIM` prefix: `VIMUser`, `VIMChannel`, `VIMCategory`, and so on.

### Sending Requests and Handling Responses

After we send that request, we'll get a `Result` enum back.  This could be either a `.Success` or a `.Failure` value.  `.Success` will contain a `Response` object, while `.Failure` will contain an `NSError`.  Switch between these two cases to handle whichever is encountered:

```Swift
vimeoClient.request(videoRequest) { result in
	switch result {
	case .Success(let response: Response):
		let video: VIMVideo = response.model
		print("retrieved video: \(video)")
	case .Failure(let error: NSError):
		print("error retrieving video: \(error)"
	}
}
```


### Collections

One neat **ProTip**: Your `Request` model type doesn't just have to be a single model object, you can also specify an array with a model object element type, like `[VIMVideo]`.  When you do so, the `model` property of your `Response` will be an array of the same type.  Note that API requests that return multiple objects like this are often paginated, see documentation on the `Response` class for tips on how to request additional pages of content.

```Swift
let staffPickedVideosRequest = Request<[VIMVideo]>(path: "/channels/staffpicks/videos")

vimeoClient.request(staffPickedVideosRequest) { result in
	switch result
	{
	case .Success(let response: Response):
		let videos: [VIMVideo] = response.model
		for video in videos
		{
			print("retrieved video: \(video)")
		}
	case .Failure(let error: NSError):
		print("error retrieving videos: \(error)"
	}
}
```


## Last remarks

With *all that* said, you now have a pretty solid understanding of what **VimeoNetworking** can do.  There's always more to explore, and we encourage you to play with the sample project, or dive right into the code and try it out yourself.  Most of our classes and functions are decently documented in the source files, so more detail on any topic can be found there.  If you still have questions or you're running into trouble, feel free to [file an issue](https://github.com/vimeo/VimeoNetworking/issues).  Better yet, if you fixed an issue or you have an improvement you'd like to share, send us a [pull request](https://github.com/vimeo/VimeoNetworking/pulls).  

**VimeoNetworking** is available under the MIT license, see the LICENSE file for more info.

###### Thanks for reading, Happy Swifting!

## Questions?

Tweet at us here: [@vimeoeng](https://twitter.com/vimeoeng).  Post on [Stackoverflow](http://stackoverflow.com/questions/tagged/vimeo-ios) with the tag `vimeo-ios`.  Get in touch [here](https://vimeo.com/help/contact).  Interested in working at Vimeo? We're [hiring](https://vimeo.com/jobs)!
