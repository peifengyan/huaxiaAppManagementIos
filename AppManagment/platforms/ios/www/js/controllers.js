angular.module('starter.controllers', [])
	.controller('LoginCtrl', function ($scope, $http, $state, $timeout, $ionicPopup, $ionicLoading) {
		$scope.user = {
			'agentCode': "8611018517",
			'password': "111111"
		}

		//登录
		$scope.login = function (user) {
			var num = Math.random();
			$state.go('home',{random:num});
			//loginFun($scope, $http, $state, user, $ionicPopup, $ionicLoading, $timeout);
		};
		$scope.findPassword = function () {
			$state.go('find-password');
		}
	})
	.controller('FindPasswordCtrl', function ($scope, $http, $state, $ionicPopup, $timeout) {
		$scope.findUser = {
			'idNo': '500112199402195788',
			'agentCode': '8611018517',
			'mobile': '13611280821'
		}
		var findUser = $scope.findUser;
		$scope.toFindPassword = function () {
			if ("" == $scope.findUser.idNo || "" == $scope.findUser.agentCode || "" == $scope.findUser.mobile) {
				$ionicPopup.alert({
					title: '找回失败',
					template: '用户名、身份证号或手机号不能为空'
				});
			} else {
				var json = {"url": API_URL + "/agentController.do", "parameters": {"method": "pwdGetBack", "idNo": $scope.findUser.idNo, "agentCode": $scope.findUser.agentCode, "mobile": $scope.findUser.mobile, "clientType": "01"}};
				httpRequestByGet(json, function (obj) {
					var returnJson = eval("(" + obj + ")");
					if (returnJson.errorCode == 200) {
						$ionicPopup.alert({
							title: '成功',
							template: returnJson.errorMessage
						});
						$state.go('login');
					} else if (returnJson.errorCode == "201") {
						alert(returnJson.errorMessage);

						/*$scope.showPopup = function() {
						 var myPopup = $ionicPopup.show({
						 template:returnJson.errorMessage,
						 scope: $scope
						 });
						 myPopup.then(function(res) {
						 console.log('Tapped!', res);
						 });
						 $timeout(function() {
						 myPopup.close(); //close the popup after 3 seconds for some reason
						 }, 3000);
						 };
						 showPopup();*/

					}
				}, function () {
					alert("网络连接错误");
				});
			}
		}
	})
	.controller('HomeCtrl', function ($scope, $rootScope, $http, $state, $compile, $interval, $ionicPopup, $timeout, $ionicLoading, $ionicModal) {
		$scope.goUserInfo = function () {
			$state.go('app.page-blank');
		};
		$scope.goMsg = function () {
			$state.go('app.my-staff');
		};
		
		$scope.user = {
				'agentCode': "8611018517",
				'password': "111111"
			}
		var currentDate = document.getElementById("currentDate");
		var lunarDate = document.getElementById("lunarDate");
		angular.element(currentDate).html('').append(GetCurrentDateTime());
		angular.element(lunarDate).html('').append('农历' + GetLunarDateTime());
		
		$timeout(function () {
			
			var networkState = navigator.connection.type;

			/**
			 * 获取经纬度
			 */
			getLocation(function (str) {
				var longitude = str[0];
				var latitude = str[1]; 
			}, function (str) {
				console.log(str);
			});

			//天气
			if (networkState.indexOf('No') < 0) {
				/**
				 * 天气实时
				 */
				var curUrl = API_URL + "/weather/v2/weather_forcasts/39.9184_116.4632/a.json?days=1";
				$http.get(curUrl).success(function (obj) {
					if (obj.status.code == 0) {
						var weatherCur = obj.data[0].weather.split(',', 1);
						$scope.weatherCurrent = {
							temperature: obj.data[0].current_temperature,
							weather: weatherCur[0],
							weatherImg: API_URL + "/weather/" + obj.data[0].img_small
						};
					}
				}).error(function (status) {
					console.log("获取天气信息失败");
				});
				/**
				 * 天气未来四天
				 */
				var weaUrl = API_URL + "/weather/v2/weather_forcasts/39.9184_116.4632/a.json?days=7";
				$http.get(weaUrl).success(function (json) {
					if (json.status.code == 0) {
						var resultData = [];
						for (var i = 0; i < json.data.length; i++) {
							json.data[i].img_small = API_URL + "/weather/" + json.data[i].img_small;
							resultData.push(json.data[i]);
							var insertCurWeather = {
								"databaseName": "WeatherDatabase",
								"tableName": "weather_info",
								"conditions": [
									{"id": i + 1}
								],
								"data": [
									{
										highest_temperature: json.data[i].highest_temperature,
										lowest_temperature: json.data[i].lowest_temperature,
										weather: json.data[i].weather,
										img_small: json.data[i].img_small,
										date: json.data[i].date
									}
								]
							};
							updateORInsertTableDataByConditions(insertCurWeather, function (data) {
								if (data == 1) {
									console.log('天气存储成功！');
								}
							}, function (error) {
								console.log(error)
							});
						}
						$scope.weatherMore = resultData;
					}
				}).error(function () {
					console.log("获取天气信息失败");
				});
			} else {
				/**
				 * 天气实时
				 */
				var wea = {
					"databaseName": "WeatherDatabase",
					"tableName": "weather_info",
					"conditions": {"id": 1}
				};
				queryTableDataByConditions(wea, function (data) {
					console.log(data);
					if (data.length) {
						console.log(data);
						var temperature = data[0].lowest_temperature.split('℃', 1);
						var weatherLow = data[0].weather.split('，', 1);
						$scope.weatherCurrent = {
							temperature: temperature[0],
							weather: weatherLow[0],
							weatherImg: data[0].img_small
						};
					}
				});
				/**
				 * 天气未来四天
				 */
				var weaMore = {
					"databaseName": "WeatherDatabase",
					'sql': 'SELECT * FROM weather_info WHERE id>1'
				};
				queryTableDataUseSql(weaMore, function (data) {
					if (data.length) {
						$scope.weatherMore = data;
					}
				});
			}
		}, 2000); 

		/*var udb = {
		 "databaseName":"UserDatabase",
		 "tableName": "current_user_info",
		 "conditions": {"agentCode": storage.getItem('agentCode')}
		 };
		 queryTableDataByConditions(udb,function(data){
		 $scope.$apply(function(){
		 $rootScope.info ={
		 icon:data[0].icon
		 };
		 });
		 });*/
		$timeout(function () {
			
			//个人信息
			var networkState = navigator.connection.type;
			if (networkState.indexOf('No') < 0) {
				var isOnLine = '在线';
			} else {
				var isOnLine = '离线';
			}

			$scope.user = {
				'password': storage.getItem('password'),
				'organCode': storage.getItem('organCode'),
				'branchType': storage.getItem('branchType'),
				'agentName': storage.getItem('agentName'),
				'agentCode': storage.getItem('agentCode'),
//				'icon':storage.getItem('icon'),
				'isOnLine': isOnLine
			};
			
			var jsonUnread = {
					"databaseName": "ChatDatabase",
					"tableName": "message_info",
					"conditions": {
						user: storage.getItem('agentCode'),
						read: 0
					}
				};
				queryTableDataByConditions(jsonUnread, function (data) {
					if (data.length) {
						$scope.staffLen = data.length;
					} else {
						$scope.staffLen = 0;
					}

				}, function () {
					console.log('查询任务消息出错！');
				});
				
				//应用列表
				loadApp($scope, $http, $compile, $ionicPopup, $ionicLoading, $timeout);
		}, 1000);
		
		$rootScope.info = {
			icon: storage.getItem('icon')
		};
//		alert(storage.getItem('icon'));
//		alert('3img'+storage.getItem('icon'));

		

		//间隔
		$interval(function () {
			loadApp($scope, $http, $compile, $ionicPopup, $ionicLoading, $timeout);
		}, 2000000);//大概33分钟执行一次
		//wifi状态自动更新下载
		//更新、下载、打开
		$scope.downloadOrUpdate = function (i) {
			/*var last = $scope.id;
			if(last==obj.appId){
				$scope.id=obj.appId+"test";
				return;
			}
			$scope.id=obj.appId;
			alert("本次点击"+obj.appId);*/

			$scope.objData = $scope.all_app[i];
			var state = document.getElementById($scope.objData.appId + "state").value;
			if ('1' == state || '2' == state) {//下载、更新
				downloadApp($scope, $http, $ionicPopup, $ionicLoading, $timeout);
			} else if ('4' == state) {//删除应用
				deleteAppFun($scope, $http, $compile, $ionicPopup, $ionicLoading, $timeout);
			} else if ('3' == state) {//打开
				var codeStyleText = $scope.objData.codeStyleText || $scope.objData.service_type
				if ('NATIVE' == codeStyleText) {//打开原生应用
					var openUrl = "";
					if (brows().android) {
						openUrl = $scope.objData.pkgname;
					} else {
						openUrl = $scope.objData.schemesUrl;
					}
					var j = {
						"userName": storage.userName,
						"password": storage.password
					}
					openApp(openUrl, j, function () {
							console.log("原生应用打开成功！")
						},
						function () {
							console.log("打开原生应用失败！")
						});
				} else if ('WEBSERVICE' == codeStyleText) {//打开WEBSERVICE应用
					openNativeApp($scope.objData.appId);
				} else {//打开SERVICE
					console.log('目前没有service应用！');
					//$state.go(page,{'appId':appId,'appsourceid':$scope.objData.appsourceid});
				}
			}
		};
		/*
		 var checked = eval("(" + storage.getItem('checked') + ")");
		 if(checked == true&&onDeviceReady()=='WiFi connection'){
		 alert('checked');
		 alert($scope.all_app.length);
		 }else{
		 alert('false')
		 }
		 */


		/**
		 * 获取应用列表
		 */

		/*$http.get(API_URL + '/app/v1/apptype/list.json').success(function(data) {
		 var appArr = [];
		 var appListBox = document.getElementById('app-list-box');
		 var appLen = data.dataList.length;
		 $scope.downText = '';
		 $scope.appTipNew = '../images/app_new.png';
		 $scope.appTipUpdate = '../images/app_update.png';
		 //			var listStr = '';
		 */
		/**/
		/*

		 //			$scope.appList = data.dataList;
		 for (var i = 0; i < appLen; i++) {
		 var apps = data.dataList[i];
		 var json = {
		 "databaseName":"AppDatabase",
		 "tableName": "app_info",
		 "conditions": {"appId":apps.appId}
		 };
		 //				alert(apps.versionId);
		 //				$scope.appList = data.dataList[i];
		 queryTableDataByConditions(json,function(localdb){
		 if(localdb.length>0){
		 //						alert(apps.versionId)
		 if(apps.versionId == localdb[0].versionId){
		 alert('打开')
		 */
		/*listStr = $compile('<div class="app-col" ng-repeat="app in appList" id="app.versionId" ng-click="download(app.ipaUrl)">'+
		 '<div class="app-box">'+
		 '<div class="app-item">'+
		 '<p class="app-img"><img src="{{app.icon}}" alt=""/><p>'+
		 '<span class="app-name">{{app.appName}}</span>'+
		 '</div>'+
		 '<div class="appdown-box show-appdown">'+
		 '<p>{{app.ipaUrl}}</p>'+
		 '<p>{{page}}</p>'+
		 '<a href="" class="app-down">点击下载</a>'+
		 '<img src="images/app_new.png" class="app-new">'+
		 '</div>'+
		 '</div>'+
		 '</div>')($scope);
		 angular.element(appListBox).append(listStr);
		 console.log(listStr);*/
		/*
		 //							$scope.$apply(function(){
		 $scope.downText = '点击打开';
		 //							});

		 //							appArr.push(apps);

		 }else if(apps.versionId > localdb[0].versionId){
		 alert('更新')
		 $scope.downText = '点击更新';
		 //							appArr.push(apps);
		 //							$scope.appList = apps;
		 }
		 }else{
		 alert('下载');
		 $scope.downText = '点击下载';

		 //						$scope.appList = apps;
		 }
		 appArr.push(apps);
		 alert($scope.downText);
		 //					alert(localdb)
		 console.log(appArr)

		 });

		 }

		 $scope.appList = appArr;



		 $scope.download = function (ipaUrl) {
		 var last = $scope.url;
		 //alert("比对 上次"+ last +"    本次"+url);
		 if(last==ipaUrl){
		 $scope.url=ipaUrl+"test";
		 return;
		 }
		 $scope.url=ipaUrl;
		 //				alert("本次点击"+ipaUrl);


		 //下载应用包
		 var modelJson = {
		 "package":"promodel/" + app.appId,
		 "url":ipaUrl
		 };
		 //				 alert(app.versionId);
		 //				 downloadZip(modelJson,function (){
		 //				 alert('应用下载成功');
		 //////////////
		 //					addAppToTable($scope);
		 */
		/**
		 * 将下载成功的应用存本地数据表
		 * @param $scope
		 */
		/**/
		/*

		 var jsonApp ={
		 "databaseName":"AppDatabase",
		 "tableName": "app_info",
		 "conditions":[{"appId": app.appId}],
		 "data": [
		 {
		 "appId": app.appId,
		 "icon":app.icon,
		 "name": app.appName,
		 "version":app.version,
		 "versionId":app.versionId,
		 "ipaUrl": app.ipaUrl
		 }
		 ]
		 };
		 //向本地库添加数据
		 updateORInsertTableDataByConditions (jsonApp,function(str){
		 if(str[0] == 1){
		 alert("数据插入成功!");
		 }else{
		 alert("数据插入失败！");
		 }
		 },function(){
		 alert("数据插入异常！");
		 });
		 */
		/*
		 */
		/*},function (){
		 alert("应用下载失败！");
		 });*/
		/*
		 }

		 }).error(function(){

		 })*/


	})


	//menu
	.controller('AppCtrl', function ($scope, $rootScope, $state, $http, $timeout, $ionicPopup) {
		//$http.get(API_URl + "UsersServlet?methodType=getUser&userId=" + storage.id).success(function(data){}
		/*var img_url = '';
		 storage.imgUrl ? img_url = 'images/icon/person_default.jpg' : img_url = imgURL + storage.imgUrl;
		 $scope.user_info = {imgUrl: img_url, name: storage.name, phoneNumber: storage.phoneNumber, businessName: storage.businessName};

		 $scope.user_type = storage.user_type;*/
		/*$scope.getHref = function () {
		 if (storage.user_type == 7) {
		 return getHref = '#/app/committee'
		 } else if (storage.user_type == 8) {
		 return getHref = '#/app/property'
		 } else {
		 return getHref = '#/app/home'
		 }
		 }*/
		/*var json = {
		 "databaseName":"UserDatabase",
		 "tableName": "current_user_info",
		 "conditions": {"agentCode": storage.getItem("agentCode")}
		 };
		 var obj = document.getElementById('user-photo').getElementsByTagName('img');
		 queryTableDataByConditions(json,function(data) {
		 var myData = data[0];
		 if(myData.localIcon.length){
		 angular.element(obj).attr('src', myData.localIcon);
		 //				alert('1'+myData.localIcon)
		 }else{
		 angular.element(obj).attr('src', '../images/defaultpic.png');
		 }
		 });*/


		$rootScope.info = {
			icon: storage.getItem("icon")
		};

		$scope.agentName =  storage.getItem("agentName");
		/**
		 * 退出登录
		 */
		$scope.logout = function () {
			$ionicPopup.confirm({
				title: '提示',
				template: '<div class="confirm">你确定要退出登录吗?</div>',
				buttons: [
					{
						text: '取消',
						onTap: function (e) {
							return true;
						}
					},
					{
						text: '<b>确定</b>',
						type: 'button-red'
					}
				]
			}).then(function (res) {
				if (res) {
					console.log('cancel');
				} else {
//					closeApplicationCenter();
					$rootScope.user = {
						agentCode: '',
						password: ''
					};
					$timeout(function () {
						storage.clear();
						$state.go('login');
					}, 500);

					/*var json ={
					 "databaseName":"UserDatabase",
					 "tableName": "current_user_info",
					 "conditions":[{"agentCode": storage.getItem("agentCode")}]
					 };
					 deleteTableData(json,function(str){
					 if (str[0]=='1') {
					 storage.clear();
					 $timeout(function () {
					 closeApplicationCenter();
					 },500);
					 }
					 });*/
				}
			});
		};
	})

	.controller('SetCtrl', function ($scope) {
		var checked = storage.getItem('checked');
		$scope.tag = eval("(" + checked + ")");
		$scope.check = function (tag) {
			storage.setItem('checked', tag);
		};
		console.log(eval("(" + checked + ")"));
	})

	.controller('UserInfoCtrl', function ($scope, $rootScope, $ionicActionSheet, $ionicLoading, $timeout, $compile) {
		/*$rootScope.infoName = 'aaf';
		 console.log($rootScope.infoName);*/
		$rootScope.info = {
			icon: storage.getItem("icon")
		};

		/*var json = {
		 "databaseName":"UserDatabase",
		 "tableName": "current_user_info",
		 "conditions": {"agentCode": storage.getItem("agentCode")}
		 };
		 var obj = document.getElementById('user-photo').getElementsByTagName('img');
		 queryTableDataByConditions(json,function(data) {
		 var myData = data[0];
		 if(myData.localIcon.length){
		 angular.element(obj).attr('src', myData.localIcon);
		 //				alert('1'+myData.localIcon)
		 }else{
		 angular.element(obj).attr('src', '../images/defaultpic.png');
		 }
		 });*/

		var accoutStateText = '';
		storage.getItem("accoutState")=='0'?accoutStateText='启用':accoutStateText = '禁用';
		$scope.userData = {
			agentCode: storage.getItem("agentCode"),   //业务员编码
			agentName: storage.getItem("agentName"),         //业务员姓名
			gender: storage.getItem("gender"),               //性别
			idType: storage.getItem("idType"),         //证件类型
			idNo: storage.getItem("idNo"),             //证件号码
			email: storage.getItem("email"),           //邮箱
			phone: storage.getItem("phone"),              //移动电话
			organId: storage.getItem("organCode"),       //机构代码
			organName: storage.getItem("organName"),       //机构名称
			group: storage.getItem("group"),             //业务员组
			agentPassword: storage.getItem("agentPassword"), //业务员密码
			permissionType: storage.getItem("permissionType"), //业务员权限类型
			state: storage.getItem("state"),              //业务员状态
			accoutState: accoutStateText,  //业务员账户状态
			branchType: storage.getItem("branchType")  //业务员渠道
//			icon:storage.getItem("icon")  //头像
		};
		/**
		 * 弹出拍照
		 */
		$scope.goAction = function () {
			$ionicActionSheet.show({
				buttons: [
					{
						text: '拍照'
					},
					{
						text: '从相册中选取'
					}
				],
				cancelText: '取消',
				cancel: function () {
					console.log('CANCELLED');
				},
				buttonClicked: function (index) {

					if (onDeviceReady().indexOf("No") != 0) {
						//在线
						var IMG_UPLOAD_URL = API_URL + '/app/agent/uploadphoto';
						var agentCode = storage.getItem("agentCode");
						var password = storage.getItem("agentPassword");
						var obj = document.getElementById('user-photo').getElementsByTagName('img');
						if (index == 0) {
							getPhotoFromCamera(function (imageURL) {
								uploadImage(IMG_UPLOAD_URL, imageURL, agentCode, password,
									function (webImgUrl) {
									/*	alert(webImgUrl.url);
										alert(webImgUrl.local);*/
//									alert('2'+webImgUrl.local);
//									angular.element(obj).attr('src', webImgUrl.local);
//									angular.element(obj).attr('src',API_URL + webImgUrl.url,);
										var insertImg = {
											"databaseName": "UserDatabase",
											"tableName": "current_user_info",
											"conditions": [
												{"AGENT_CODE": storage.getItem('agentCode')}
											],
											"data": [
												{
													"icon": webImgUrl.local,
													"localIcon": webImgUrl.url
												}
											]
										};
										updateORInsertTableDataByConditions(insertImg, function (data) {
											if (data == 1) {
												console.log('图片存储成功！');
											}
										});
										$scope.$apply(function () {
											storage.setItem('icon', webImgUrl.local);
											$rootScope.info = {
												icon: webImgUrl.local
											}
										})
									}, function () {
//									alert('上传失败');
										$ionicLoading.show({
											template: '上传失败!'
										});
										$timeout(function () {
											$ionicLoading.hide();
										}, 1000);
									}
								)
							}, function () {
//							alert('调用相机失败')
								$ionicLoading.show({
									template: '调用相机失败!'
								});
								$timeout(function () {
									$ionicLoading.hide();
								}, 1000);
							});
						} else if (index == 1) {
							getPhotoFromAlbum(1, function (imageURL) {
								uploadImage(IMG_UPLOAD_URL, imageURL, agentCode, password,
									function (webImgUrl) {
//									angular.element(obj).attr('src', webImgUrl.local);
//									angular.element(obj).attr('src',API_URL + webImgUrl.url,);
										var insertImg = {
											"databaseName": "UserDatabase",
											"tableName": "current_user_info",
											"conditions": [
												{"AGENT_CODE": storage.getItem('agentCode')}
											],
											"data": [
												{
													"icon": webImgUrl.local,
													"localIcon": API_URL + webImgUrl.url
												}
											]
										};
										updateORInsertTableDataByConditions(insertImg, function (data) {
											if (data == 1) {
												console.log('图片存储成功！');
											}
										});
										$scope.$apply(function () {
											storage.setItem('icon', webImgUrl.local);
											$rootScope.info = {
												icon: webImgUrl.local
											}
										})
									}, function () {
//									alert('上传失败');
										$ionicLoading.show({
											template: '上传失败!'
										});
										$timeout(function () {
											$ionicLoading.hide();
										}, 1000);
									}
								)
							}, function () {
//							alert('调用相册失败')
								$ionicLoading.show({
									template: '调用相册失败!'
								});
								$timeout(function () {
									$ionicLoading.hide();
								}, 1000);
							})
						}
						return true;
					} else {
						//离线
						$ionicLoading.show({
							template: '离线不能修改头像!'
						});
						$timeout(function () {
							$ionicLoading.hide();
						}, 1000);
					}

				}
			});
		};
	})


	.controller('UpdatePasswordCtrl', function ($scope, $timeout, $ionicPopup, $ionicLoading) {
		$scope.password = {
			oldPwd: '',
			newPwd: '',
			repeatNewPwd: ''
		};
		$scope.changePassword = function (password) {
			if (password.oldPwd == "" || password.newPwd == "" || password.repeatNewPwd == "") {
				$ionicLoading.show({
					template: '请输入正确的密码!'
				});
				$timeout(function () {
					$ionicLoading.hide();
				}, 1000);
			} else if (password.newPwd !== password.repeatNewPwd) {
				$ionicLoading.show({
					template: '两次输入的密码不一致!'
				});
				$timeout(function () {
					$ionicLoading.hide();
				}, 1000);
			} else {
				var json = {"url": API_URL + "/agentController.do", "parameters": {"method": "modifyPwd", "agentCode": storage.getItem("agentCode"), "oldPwd": password.oldPwd, "newPwd": password.newPwd, "clientType": "01"}};
				httpRequestByPost(json, function (obj) {
					var returnData = eval("(" + obj + ")");
					if (returnData.errorCode == 200) {
						$ionicLoading.show({
							template: '密码修改成功!'
						});
						$timeout(function () {
							$ionicLoading.hide();
							storage.setItem("agentPassword", password.newPwd); //业务员密码
						}, 1000);
					} else if (returnData.errorCode == 201) {
						$ionicLoading.show({
							template: '旧密码不正确!'
						});
						$timeout(function () {
							$ionicLoading.hide();
						}, 1000);
					} else {
						$ionicLoading.show({
							template: '服务器错误!'
						});
						$timeout(function () {
							$ionicLoading.hide();
						}, 1000);
					}
				}, function () {
//					alert("修改密码失败");
					$ionicLoading.show({
						template: '离线不能修改密码!'
					});
					$timeout(function () {
						$ionicLoading.hide();
					}, 1000);
				})

			}
		}
	})

	.controller('MyStaffCtrl', function ($scope, $rootScope, $timeout, $ionicLoading) {
//		var readType = 1;
		/*$ionicLoading.show({
		 template: 'Loading...'
		 });*/
		var jsonUnread = {
			"databaseName": "ChatDatabase",
			"tableName": "message_info",
			"conditions": {
				user: storage.getItem('agentCode'),
				read: 0
			}
		};
		queryTableDataByConditions(jsonUnread, function (data) {
			if (data.length) {
				//未读消息
				console.log(data);
				$scope.itemsUnread = data;
			}

		}, function () {
			console.log('查询任务消息出错！');
		});
		var jsonReaded = {
			"databaseName": "ChatDatabase",
			"tableName": "message_info",
			"conditions": {
				user: storage.getItem('agentCode'),
				read: 1
			}
		};
		queryTableDataByConditions(jsonReaded, function (data) {
			if (data.length) {
				//已读未读消息
				console.log(data);
				$scope.itemsReaded = data;
			}

		}, function () {
			console.log('查询任务消息出错！');
		});

	})

	/**
	 * 消息详情
	 */
	.controller('StaffViewCtrl', function ($scope, $stateParams, $state) {
		var json = {
			"databaseName": "ChatDatabase",
			"tableName": "message_info",
			"conditions": {
				id: $stateParams.id
			}
		};
		queryTableDataByConditions(json, function (data) {
			if (data.length) {
				console.log(data);
				$scope.view = data[0];
			}

		}, function () {
			console.log('查询任务消息出错！');
		});
		//修改为已读
		var jsonUpdate = {
			"databaseName": "ChatDatabase",
			"tableName": "message_info",
			"conditions": [
				{
					id: $stateParams.id
				}
			],
			"data": [
				{
					"read": 1
				}
			]
		};
		updateORInsertTableDataByConditions(jsonUpdate, function (data) {
			if (data == 1) {
				alert('已读！');
			}
		});

		$scope.prev = function () {
			/*previd = $stateParams.id - 1;
			alert(typeof previd);
			$state.go('app.staff-view', {id: previd})*/
		}
		$scope.next = function () {
			alert($stateParams.id + 1);
			var nextid = $stateParams.id + 1;
			$state.go('app.staff-view', {id: nextid})
		}

	})
;


/*
 {
 "agentInfo": {
 "agentCode": "8611018517",
 "agentName": "周洁",
 "gender": "1",
 "birthday": "1994-02-19",
 "idType": "0",
 "idNo": "500112199402195788",
 "phone": "15923003477",
 "organId": "86110001",
 "group": "000000043407",
 "password": "96E79218965EB72C92A549DD5A330112",
 "permissionType": "3",
 "state": "01",
 "accountState": "0",
 "branchType": "1",
 "icon": "/emm_backend_static/icon/201412101333490587.jpg"
 },
 "errorCode": "200"
 }
 */
