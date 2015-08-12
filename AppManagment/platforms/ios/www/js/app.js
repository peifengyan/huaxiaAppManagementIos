// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.controllers' is found in controllers.js
angular.module('starter', ['ionic', 'starter.controllers'])

	.run(function ($ionicPlatform) {
		$ionicPlatform.ready(function () {
			// Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
			// for form inputs)
			if (window.cordova && window.cordova.plugins.Keyboard) {
				cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
			}
			if (window.StatusBar) {
				// org.apache.cordova.statusbar required
				StatusBar.styleDefault();
			}
		});
	})

	.config(function ($stateProvider, $urlRouterProvider) {
		/* $stateProvider
		 .state('login', {
		 url: "/login",
		 views: {
		 'MainContent' :{
		 templateUrl: "templates/login.html",
		 controller: 'LoginCtrl'
		 }
		 }
		 })
		 .state('app', {
		 url: "/app",
		 views: {
		 'MainContent' :{
		 templateUrl: "templates/menu.html",
		 controller: 'AppCtrl'
		 }
		 }
		 })

		 .state('app.page-blank', {
		 url: "/page-blank",
		 views: {
		 'MenuContent' :{
		 templateUrl: "templates/page-blank.html"
		 }
		 }
		 })
		 .state('app.user-info', {
		 url: "/user-info",
		 views: {
		 'MenuContent' :{
		 templateUrl: "templates/user-info.html",
		 controller: 'UserInfoCtrl'
		 }
		 }
		 })
		 .state('app.set', {
		 url: "/set",
		 views: {
		 'MenuContent' :{
		 templateUrl: "templates/set.html",
		 controller: 'SetCtrl'
		 }
		 }
		 })

		 .state('app.update-password', {
		 url: "/update-password",
		 views: {
		 'MenuContent' :{
		 templateUrl: "templates/update-password.html",
		 controller: 'UpdatePasswordCtrl'
		 }
		 }
		 })

		 .state('home', {
		 url: "/home",
		 views: {
		 'MainContent' :{
		 templateUrl: "templates/home.html",
		 controller: 'HomeCtrl'
		 }
		 }
		 })

		 .state('msg', {
		 url: "/msg",
		 views: {
		 'MainContent' :{
		 templateUrl: "templates/menu-msg.html"
		 //				  controller: 'MsgCtrl'
		 }
		 }
		 })
		 .state('msg.page-blank', {
		 url: "/page-blank",
		 views: {
		 'MsgMenuContent' :{
		 templateUrl: "templates/page-blank.html"
		 }
		 }
		 })
		 .state('msg.msg-view', {
		 url: "/msg-view",
		 views: {
		 'MsgMenuContent' :{
		 templateUrl: "templates/msg-view.html"
		 }
		 }
		 })

		 ;
		 $urlRouterProvider.otherwise('/login');
		 */

		if (platform == 'phone') {
			$stateProvider
				.state('login', {
					url: "/login",
					views: {
						'MainContent': {
							templateUrl: "templates/login.html",
							controller: 'LoginCtrl'
						}
					}
				})
				.state('app', {
					url: "/app",
					views: {
						'MainContent': {
							templateUrl: "templates/app-phone.html",
							controller: 'AppCtrl'
						}
					}
				})
				.state('app.page-blank', {
					url: "/page-blank",
					views: {
						'MenuContent': {
							templateUrl: "templates/menu-phone.html"
						}
					}
				})
				.state('app.user-info', {
					url: "/user-info",
					views: {
						'MenuContent': {
							templateUrl: "templates/user-info.html",
							controller: 'UserInfoCtrl'
						}
					}
				})
				.state('app.my-staff', {
					url: "/my-staff",
					views: {
						'MenuContent': {
							templateUrl: "templates/my-staff.html",
							controller: 'MyStaffCtrl'
						}
					}
				})
				.state('app.staff-view', {
					url: "/staff-view/:id",
					views: {
						'MenuContent': {
							templateUrl: "templates/staff-view.html",
							controller: 'StaffViewCtrl'
						}
					}
				})
				.state('app.set', {
					url: "/set",
					views: {
						'MenuContent': {
							templateUrl: "templates/set.html",
							controller: 'SetCtrl'
						}
					}
				})

				.state('app.update-password', {
					url: "/update-password",
					views: {
						'MenuContent': {
							templateUrl: "templates/update-password.html",
							controller: 'UpdatePasswordCtrl'
						}
					}
				})

				.state('home', {
					url: "/home",
					views: {
						'MainContent': {
							templateUrl: "templates/home.html",
							controller: 'HomeCtrl'
						}
					}
				})

				.state('msg', {
					url: "/msg",
					views: {
						'MainContent': {
							templateUrl: "templates/menu-msg.html"
//				  controller: 'MsgCtrl'
						}
					}
				})
				.state('msg.page-blank', {
					url: "/page-blank",
					views: {
						'MsgMenuContent': {
							templateUrl: "templates/page-blank.html"
						}
					}
				})
				.state('msg.msg-view', {
					url: "/msg-view",
					views: {
						'MsgMenuContent': {
							templateUrl: "templates/msg-view.html"
						}
					}
				})
				.state('app.help', {
					url: "/help",
					views: {
						'MenuContent': {
							templateUrl: "templates/help.html"
						}
					}
				})
			;
			$urlRouterProvider.otherwise('/home');
		} else {
			$stateProvider
				.state('login', {
					url: "/login",
					views: {
						'MainContent': {
							templateUrl: "templates/login.html",
							controller: 'LoginCtrl'
						}
					}
				})
				.state('app', {
					url: "/app",
					views: {
						'MainContent': {
							templateUrl: "templates/menu.html",
							controller: 'AppCtrl'
						}
					}
				})


				.state('app.page-blank', {
					url: "/page-blank",
					views: {
						'MenuContent': {
							templateUrl: "templates/page-blank.html"
						}
					}
				})
				.state('app.user-info', {
					url: "/user-info",
					views: {
						'MenuContent': {
							templateUrl: "templates/user-info.html",
							controller: 'UserInfoCtrl'
						}
					}
				})
				.state('app.set', {
					url: "/set",
					views: {
						'MenuContent': {
							templateUrl: "templates/set.html",
							controller: 'SetCtrl'
						}
					}
				})
				.state('app.my-staff', {
					url: "/my-staff",
					views: {
						'MenuContent': {
							templateUrl: "templates/my-staff.html",
							controller: 'MyStaffCtrl'
						}
					}
				})
				.state('app.staff-view', {
					url: "/staff-view/:id",
					views: {
						'MenuContent': {
							templateUrl: "templates/staff-view.html",
							controller: 'StaffViewCtrl'
						}
					}
				})
				.state('app.update-password', {
					url: "/update-password",
					views: {
						'MenuContent': {
							templateUrl: "templates/update-password.html",
							controller: 'UpdatePasswordCtrl'
						}
					}
				})

				.state('home', {
					url: "/home",
					views: {
						'MainContent': {
							templateUrl: "templates/home.html",
							controller: 'HomeCtrl'
						}
					}
				})

				.state('msg', {
					url: "/msg",
					views: {
						'MainContent': {
							templateUrl: "templates/menu-msg.html"
//				 		controller: 'MsgCtrl'
						}
					}
				})
				.state('msg.page-blank', {
					url: "/page-blank",
					views: {
						'MsgMenuContent': {
							templateUrl: "templates/page-blank.html"
						}
					}
				})
				.state('msg.msg-view', {
					url: "/msg-view",
					views: {
						'MsgMenuContent': {
							templateUrl: "templates/msg-view.html"
						}
					}
				})
				.state('app.help', {
					url: "/help",
					views: {
						'MenuContent': {
							templateUrl: "templates/help.html"
						}
					}
				})


			;
			$urlRouterProvider.otherwise('/home');
		}
		// if none of the above states are matched, use this as the fallback


	});

