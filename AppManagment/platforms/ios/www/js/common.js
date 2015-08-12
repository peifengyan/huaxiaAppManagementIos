//http://10.0.22.78:9000/eSalesService/agentController.do?method=login
var platform = 'phone';
//var API_URL = "http://10.0.22.78:7003";
var API_URL = "http://123.57.41.120:8082";
var storage = window.localStorage;
var dataBaseName = "esales.sqlite";


function goLogin() {
	window.location.href = '#/login';
}
function loginFun($scope, $http, $state, user, $ionicPopup, $ionicLoading, $timeout) {
	// device APIs are available
	if ("" == user.agentCode || "" == user.password) {
		$ionicPopup.alert({
			title: '登录失败',
			template: '用户名或密码不能为空'
		});
	} else {
		/* $ionicLoading.show({
		 template: 'Loading...'
		 });*/
//       alert(onDeviceReady());
		if (onDeviceReady().indexOf("No") == 0) {//离线处理
//		  $ionicLoading.hide();
//        alert("您已离线");
			var jsonLoginOutline = {
				"databaseName": "UserDatabase",
				"tableName": "current_user_info",
				"conditions": {"AGENT_CODE": user.agentCode}
			};
			queryTableDataByConditions(jsonLoginOutline, function (data) {
				if (data.length) {
					var myData = data[0];
					if (myData.AGENT_CODE == user.agentCode && myData.PASSWORD == user.password) {
						if (myData.status == 0) {
							$ionicLoading.show({
								template: '离线登录成功!'
							});
							$timeout(function () {
								$ionicLoading.hide();
								$state.go('home');
							}, 1000);
							var insertJson = {
								"databaseName": "UserDatabase",
								"tableName": "current_user_info",
								"conditions": [
									{"AGENT_CODE": user.agentCode}
								],
								"data": [
									{
										"localLoginTime": new Date().getTime()
									}
								]
							};
							updateORInsertTableDataByConditions(insertJson, function (data) {
								if (data == 1) {
									console.log('本地登录时间存储成功！');
								}
							});

							/*//登录成功后存本地数据
							"ACCOUNT_STATE": myData.ACCOUNT_STATE,
								"AGENT_CODE": myData.AGENT_CODE,
//								"icon": localUrl,
								"AGENT_NAME": myData.AGENT_NAME,
								"BRANCH_TYPE_TEXT": myData.BRANCH_TYPE_TEXT,
								"GENDER_TEXT": myData.GENDER_TEXT,
								"AGENT_GROUP": myData.AGENT_GROUP,
								"IDNO": myData.IDNO,
								"IDTYPE_TEXT": myData.IDTYPE_TEXT,
								"ORGAN_ID": myData.ORGAN_ID,
								"AGENT_NAME": myData.AGENT_NAME,
								"password": user.password,
								"PERMISSION_TYPE_TEXT": myData.PERMISSION_TYPE_TEXT,
								"PHONE": myData.PHONE,
								"AGENT_STATE_TEXT": myData.AGENT_STATE_TEXT,
								"status": 0,
								"serviceLoginTime": new Date().getTime()*/
							storage.setItem("agentName", myData.AGENT_NAME);          //业务员姓名
							storage.setItem("password", user.password);
							storage.setItem("phone", myData.PHONE);             //移动电话
							storage.setItem("organCode", myData.ORGAN_ID);       //机构代码
							storage.setItem("organName", myData.ORGAN_ID_TEXT);       //机构名称
							storage.setItem("branchType", myData.BRANCH_TYPE_TEXT);   //业务员渠道
							storage.setItem("agentCode", myData.AGENT_CODE);     //业务员编码
							storage.setItem("gender", myData.GENDER_TEXT);                 //性别
							storage.setItem("idType", myData.IDTYPE_TEXT);           //证件类型
							storage.setItem("idNo", myData.IDNO);               //证件号码
							storage.setItem("email", myData.EMAIL);             //邮箱
							storage.setItem("group", myData.AGENT_GROUP_TEXT);             //业务员组
							storage.setItem("agentPassword", myData.PASSWORD); //业务员密码
							storage.setItem("permissionType", myData.PERMISSION_TYPE_TEXT); //业务员权限类型
							storage.setItem("state", myData.AGENT_STATE_TEXT);              //业务员状态
							storage.setItem("accoutState", myData.ACCOUNT_STATE);  //业务员账户状态
							storage.setItem("icon", myData.ICON);  //头像
						} else {
							$ionicLoading.show({
								template: '您的离线登录已过期，请连接网络重新登录!'
							});
							$timeout(function () {
								$ionicLoading.hide();
							}, 1500);
						}
					} else {
						$ionicLoading.show({
							template: '用户名或密码错误!'
						});
						$timeout(function () {
							$ionicLoading.hide();
						}, 1500);
					}
				} else {
					$ionicLoading.show({
						template: '初次登录，请连接网络!'
					});
					$timeout(function () {
						$ionicLoading.hide();
					}, 1500);
				}

			}, function () {
//			alert(1)
			});
		} else {
			var json = {"url": API_URL + "/app/agent/login", "parameters": {"agentCode": user.agentCode, "password": user.password}};
			httpRequestByPost(json, function (data) {
//			  $ionicLoading.hide();
				var returnJson = eval("(" + data + ")");
				if (returnJson.status.code == 0) {
					var myData = returnJson.jsonMap;
					console.log(myData);
				 	$ionicLoading.show({
						template: '登录成功!'
					});
					$timeout(function () {
						$ionicLoading.hide();
						var num = Math.random();
						$state.go('home');
					}, 1000);
				  	var imgUrl = '';
					if (!myData.ICON) {
						imgUrl = 'images/defaultpic.png';
						storage.setItem("icon", imgUrl);  //头像
//						alert(imgUrl)
					} else {
						//把头像保存到本地
//						alert(myData.ICON);

						$scope.$apply(function(){
							var save = {"saveImagePath": "", "downLoadPath": myData.ICON};
							saveImageToNative(save, function (data) {
								imgUrl = data;
								//						  alert(2+imgUrl);
								storage.setItem("icon", imgUrl);  //头像
								//							alert(imgUrl);
								var imgJson = {
									"databaseName": "UserDatabase",
									"tableName": "current_user_info",
									"conditions": [
										{"AGENT_CODE": user.agentCode}
									],
									"data": [
										{
											"ICON": imgUrl
										}
									]
								};
								updateORInsertTableDataByConditions(imgJson, function (str) {
									if (1 == str[0]) {
										console.log("存本地表成功")
									}
								}, function (error) {
									console.log(error)
								})

							}, function (error) {
								console.log('error')
							});
						})

					}
//				  alert(webUrl);
					//登录成功后存本地数据
					storage.setItem("agentName", myData.AGENT_NAME);          //业务员姓名
					storage.setItem("password", user.password);
					storage.setItem("phone", myData.PHONE);             //移动电话
					storage.setItem("organCode", myData.ORGAN_ID);       //机构代码
					storage.setItem("organName", myData.ORGAN_ID_TEXT);       //机构名称
					storage.setItem("branchType", myData.BRANCH_TYPE_TEXT);   //业务员渠道
					storage.setItem("agentCode", myData.AGENT_CODE);     //业务员编码
					storage.setItem("gender", myData.GENDER_TEXT);                 //性别
					storage.setItem("idType", myData.IDTYPE_TEXT);           //证件类型
					storage.setItem("idNo", myData.IDNO);               //证件号码
					storage.setItem("email", myData.EMAIL);             //邮箱
					storage.setItem("group", myData.AGENT_GROUP_TEXT);             //业务员组
					storage.setItem("agentPassword", myData.PASSWORD); //业务员密码
					storage.setItem("permissionType", myData.PERMISSION_TYPE_TEXT); //业务员权限类型
					storage.setItem("state", myData.AGENT_STATE_TEXT);              //业务员状态
					storage.setItem("accoutState", myData.ACCOUNT_STATE);  //业务员账户状态

					var jsonLoginOnline = {
						"databaseName": "UserDatabase",
						"tableName": "current_user_info",
						"conditions": [
							{"AGENT_CODE": user.agentCode}
						],
						"data": [
							{
								"ACCOUNT_STATE": myData.ACCOUNT_STATE,
								"AGENT_CODE": myData.AGENT_CODE,
//								"icon": localUrl,
								"AGENT_NAME": myData.AGENT_NAME,
								"BRANCH_TYPE_TEXT": myData.BRANCH_TYPE_TEXT,
								"GENDER_TEXT": myData.GENDER_TEXT,
								"AGENT_GROUP": myData.AGENT_GROUP,
								"IDNO": myData.IDNO,
								"IDTYPE_TEXT": myData.IDTYPE_TEXT,
								"ORGAN_ID": myData.ORGAN_ID,
//								"AGENT_NAME": myData.AGENT_NAME,
								"PASSWORD": user.password,
								"PERMISSION_TYPE_TEXT": myData.PERMISSION_TYPE_TEXT,
								"PHONE": myData.PHONE,
								"AGENT_STATE_TEXT": myData.AGENT_STATE_TEXT,
								"status": 0,
								"serviceLoginTime": new Date().getTime()
								//				"localLoginTime":new Date().getTime()
							}
						]
					};
					updateORInsertTableDataByConditions(jsonLoginOnline, function (str) {
						if (1 == str[0]) {
							console.log("存本地表成功")
						}
					}, function (error) {
						console.log(error)
					})
				} else{
					$ionicLoading.show({
						template: returnJson.status.msg
					});
					$timeout(function () {
						$ionicLoading.hide();
					}, 1500);
				}
			}, function () {
				alert("服务器错误,请稍候再试！");
			});
		}
	}
}
//天气预报当天
function loadCurrentWeather($scope, $http, $compile, strjd, strwd) {
	if (onDeviceReady().indexOf("No") == 0) {//不在线
		if (storage.currentWea) {
			var returnJson = eval('(' + storage.currentWea + ')');
			var dataArr = returnJson.data;
			var weaStr = '';
			weaStr += '<li class="curr-w">' +
				'<p class="w-addr">北京</p>' +
				'<div>' +
				'<div class="w-temp">' +
				'<p class="w-size">' + dataArr[0].current_temperature + '<sup>o</sup></p>' +
				'<p class="w-word">' + dataArr[0].weather + '</p>' +
				'</div>' +
				'<img src=' + API_URL + "/weather/" + dataArr[0].img_small + ' />' +
				'</div>' +
				'</li>';
			var txt = $compile(weaStr)($scope);
			var el = document.getElementById("currentWea");
			angular.element(el).html('').append(txt);
		}
		return;
	}
	var json = {
		"url": API_URL + "/weather/v2/weather_forcasts/" + strjd + "_" + strwd + "/a.json",
		"parameters": {
			"days": "1"
		}
	};
	httpRequestByGet(json, function (obj) {
		var returnJson = eval('(' + obj + ')');
		if (returnJson.status.code == 0) {

//			alert(returnJson.data[0].current_temperature);
			$scope.weatherCurrent = returnJson.data[0];
//        storage.setItem("currentWea",obj);
			var weaStr = '';
			weaStr += '<li class="curr-w">' +
				'<p class="w-addr">北京</p>' +
				'<div>' +
				'<div class="w-temp">' +
				'<p class="w-size">' + dataArr[0].current_temperature + '<sup>o</sup></p>' +
				'<p class="w-word">' + dataArr[0].weather + '</p>' +
				'</div>' +
				'<img src=' + API_URL + "/weather/" + dataArr[0].img_small + ' />' +
				'</div>' +
				'</li>';
			var txt = $compile(weaStr)($scope);
			var el = document.getElementById("currentWea");
			angular.element(el).html('').append(txt);
			$scope.weatherCurrent = {
				temperature: dataArr[0].current_temperature,
				weather: dataArr[0].weather,
				weatherImg: API_URL + "/weather/" + dataArr[0].img_small
			}
		}
	}, function () {
		console.log("网络连接错误");
	});
}
//天气预报
function loadOtherWeather($scope, $http, $compile, strjd, strwd) {
	if (onDeviceReady().indexOf("No") == 0) {//不在线
		if (storage.otherWea) {
			var returnJson = eval('(' + storage.otherWea + ')');
			var dataArr = returnJson.data;
			var weaStr = '';
			for (var i = 1; i < dataArr.length - 2; i++) {
				weaStr += '<li class="other-w">' +
					'<p class="">' + dataArr[i].date + '</p>' +
					'<p class=""><img src=' + API_URL + "/weather/" + dataArr[i].img_small + ' /></p>' +
					'<p class="">' + parseInt(dataArr[i].lowest_temperature) + '<sup>o</sup> / ' + parseInt(dataArr[i].highest_temperature) + '<sup>o</sup></p>' +
					'</li>'
			}
			var txt = $compile(weaStr)($scope);
			var el = document.getElementById("otherWea");
			angular.element(el).html('').append(txt);
		}
		return;
	}
	var json = {"url": API_URL + "/weather/v2/weather_forcasts/" + strjd + "_" + strwd + "/a.json", "parameters": {"days": "7"}};
	httpRequestByGet(json, function (obj) {
		var returnJson = eval('(' + obj + ')');
		if (returnJson.status.code == 0) {
			var dataArr = returnJson.data;
			storage.setItem("otherWea", obj);
			var weaStr = '';
			for (var i = 1; i < dataArr.length - 2; i++) {
				weaStr += '<li class="other-w">' +
					'<p class="">' + dataArr[i].date + '</p>' +
					'<p class=""><img src=' + API_URL + "/weather/" + dataArr[i].img_small + ' /></p>' +
					'<p class="">' + parseInt(dataArr[i].lowest_temperature) + '<sup>o</sup> / ' + parseInt(dataArr[i].highest_temperature) + '<sup>o</sup></p>' +
					'</li>'
			}
			var txt = $compile(weaStr)($scope);
			var el = document.getElementById("otherWea");
			angular.element(el).html('').append(txt);
			$scope.weather = {
				temperature: dataArr[0].current_temperature,
				weather: dataArr[0].weather,
				weatherImg: API_URL + "/weather/" + dataArr[0].img_small
			}
		}
	}, function () {
		console.log("网络连接错误");
	});
}
// 获取当前阳历
function GetCurrentDateTime() {
	var d = new Date();
	var year = d.getFullYear();
	var month = d.getMonth() + 1;
	var date = d.getDate();
	var week = d.getDay();
	var curDateTime = year;
	if (month > 9)
		curDateTime = curDateTime + "年" + month;
	else
		curDateTime = curDateTime + "年0" + month;
	if (date > 9)
		curDateTime = curDateTime + "月" + date + "日";
	else
		curDateTime = curDateTime + "月0" + date + "日";
	var weekday = "";
	if (week == 0)
		weekday = "星期日";
	else if (week == 1)
		weekday = "星期一";
	else if (week == 2)
		weekday = "星期二";
	else if (week == 3)
		weekday = "星期三";
	else if (week == 4)
		weekday = "星期四";
	else if (week == 5)
		weekday = "星期五";
	else if (week == 6)
		weekday = "星期六";
	curDateTime = curDateTime + " " + weekday;
	return curDateTime;
}
//获取当前农历
function GetLunarDateTime() {
	var CalendarData = new Array(100);
	var madd = new Array(12);
	var numString = "一二三四五六七八九十";
	var monString = "正二三四五六七八九十冬腊";
	var cYear, cMonth, cDay, TheDate;
	CalendarData = new Array(0xA4B, 0x5164B, 0x6A5, 0x6D4, 0x415B5, 0x2B6, 0x957, 0x2092F, 0x497, 0x60C96, 0xD4A, 0xEA5, 0x50DA9, 0x5AD, 0x2B6, 0x3126E, 0x92E, 0x7192D, 0xC95, 0xD4A, 0x61B4A, 0xB55, 0x56A, 0x4155B, 0x25D, 0x92D, 0x2192B, 0xA95, 0x71695, 0x6CA, 0xB55, 0x50AB5, 0x4DA, 0xA5B, 0x30A57, 0x52B, 0x8152A, 0xE95, 0x6AA, 0x615AA, 0xAB5, 0x4B6, 0x414AE, 0xA57, 0x526, 0x31D26, 0xD95, 0x70B55, 0x56A, 0x96D, 0x5095D, 0x4AD, 0xA4D, 0x41A4D, 0xD25, 0x81AA5, 0xB54, 0xB6A, 0x612DA, 0x95B, 0x49B, 0x41497, 0xA4B, 0xA164B, 0x6A5, 0x6D4, 0x615B4, 0xAB6, 0x957, 0x5092F, 0x497, 0x64B, 0x30D4A, 0xEA5, 0x80D65, 0x5AC, 0xAB6, 0x5126D, 0x92E, 0xC96, 0x41A95, 0xD4A, 0xDA5, 0x20B55, 0x56A, 0x7155B, 0x25D, 0x92D, 0x5192B, 0xA95, 0xB4A, 0x416AA, 0xAD5, 0x90AB5, 0x4BA, 0xA5B, 0x60A57, 0x52B, 0xA93, 0x40E95);
	madd[0] = 0;
	madd[1] = 31;
	madd[2] = 59;
	madd[3] = 90;
	madd[4] = 120;
	madd[5] = 151;
	madd[6] = 181;
	madd[7] = 212;
	madd[8] = 243;
	madd[9] = 273;
	madd[10] = 304;
	madd[11] = 334;

	function GetBit(m, n) {
		return (m >> n) & 1;
	}

	function e2c() {
		TheDate = (arguments.length != 3) ? new Date() : new Date(arguments[0], arguments[1], arguments[2]);
		var total, m, n, k;
		var isEnd = false;
		var tmp = TheDate.getYear();
		if (tmp < 1900) {
			tmp += 1900;
		}
		total = (tmp - 1921) * 365 + Math.floor((tmp - 1921) / 4) + madd[TheDate.getMonth()] + TheDate.getDate() - 38;

		if (TheDate.getYear() % 4 == 0 && TheDate.getMonth() > 1) {
			total++;
		}
		for (m = 0; ; m++) {
			k = (CalendarData[m] < 0xfff) ? 11 : 12;
			for (n = k; n >= 0; n--) {
				if (total <= 29 + GetBit(CalendarData[m], n)) {
					isEnd = true;
					break;
				}
				total = total - 29 - GetBit(CalendarData[m], n);
			}
			if (isEnd) break;
		}
		cYear = 1921 + m;
		cMonth = k - n + 1;
		cDay = total;
		if (k == 12) {
			if (cMonth == Math.floor(CalendarData[m] / 0x10000) + 1) {
				cMonth = 1 - cMonth;
			}
			if (cMonth > Math.floor(CalendarData[m] / 0x10000) + 1) {
				cMonth--;
			}
		}
	}

	function GetcDateString() {
		var tmp = "";
		if (cMonth < 1) {
			tmp += "(闰)";
			tmp += monString.charAt(-cMonth - 1);
		} else {
			tmp += monString.charAt(cMonth - 1);
		}
		tmp += "月";
		tmp += (cDay < 11) ? "初" : ((cDay < 20) ? "十" : ((cDay < 30) ? "廿" : "三十"));
		if (cDay % 10 != 0 || cDay == 10) {
			tmp += numString.charAt((cDay - 1) % 10);
		}
		return tmp;
	}

	function GetLunarDay(solarYear, solarMonth, solarDay) {
		//solarYear = solarYear<1900?(1900+solarYear):solarYear;
		if (solarYear < 1921 || solarYear > 2020) {
			return "";
		} else {
			solarMonth = (parseInt(solarMonth) > 0) ? (solarMonth - 1) : 11;
			e2c(solarYear, solarMonth, solarDay);
			return GetcDateString();
		}
	}

	var D = new Date();
	var yy = D.getFullYear();
	var mm = D.getMonth() + 1;
	var dd = D.getDate();
	var ww = D.getDay();
	var ss = parseInt(D.getTime() / 1000);
	if (yy < 100) yy = "19" + yy;
	return GetLunarDay(yy, mm, dd);
}
//查询应用详情
function loadAppInfo($scope, $http, appId) {
	var json = {"url": API_URL + "/appStore.json?appId=" + appId};
	httpRequestByPost(json, function (obj) {
		if (0 == obj.status.code) {
			$scope.objData = obj.data;
		}
	}, function () {
		console.log("网络连接错误");
	});

}
//查询应用
function loadApp($scope, $http, $compile, $ionicPopup, $ionicLoading, $timeout) {
	
	 var modelType = platform == 'pad'?'2':'1';
	 var osId = '1';
	 if(brows().android){
	 osId = 2;
	 }
	 
	if (onDeviceReady().indexOf("No") != 0) {//检测当前设备是否有网 如果有网查询服务器
		var json = {"url": API_URL + "/emm_backend/app/v1/appStore/list.json"};
		httpRequestByPost(json, function (appObj) {
			var returnJson = eval("(" + appObj + ")");
			if (0 == returnJson.status.code) {
				var data = returnJson.dataList;
				$scope.$apply(function () {
					$scope.all_app = data;
				});
				//checkApp(0, data, "", $scope, $compile, $http, $ionicPopup, $ionicLoading, $timeout);
//				var obj
				var appStr = "";
				var statusUp = "";
				var el = document.getElementById("app-list-box");

				for (var i = 0; i < data.length; i++) {
					check(i,data[i]);
				}


				function check(i,obj) {
					var json = {
					 "databaseName": "AppDatabase",
					 "tableName": "app_info",
					 "conditions": {"appId": obj.appId}
					 };
					 queryTableDataByConditions(json, function (req) {
						 if(req.length){
							 if(obj.appStatus == '1'){
								 if (obj.versionId == req[0].versionId) {
								 //直接打开状态
//									 alert('打开');
									 statusUp = '<input type="hidden" id="' + obj.appId + 'state" value="3">';
								 } else {
								 //更新状态
//									 alert('更新');
									 statusUp = '<input type="hidden" id="' + obj.appId + 'state" value="2">' +
										 '<div class="appdown-box show-appdown" id="' + obj.appId + 'li"><a href="javascript:;" class="app-down">点击更新</a>' +
										 '<img src="images/app_update.png" class="app-new">' +
										 '</div>';
								 }
								 appStr += '<div class="app-col"><div class="app-box" ng-click="downloadOrUpdate('+ i +')"><div class="app-item">' +
									 '<p class="app-img"><img src="' + obj.icon + '" /><p><span class="app-name">' + obj.appName + '</span></div>' + statusUp +
									 '</div></div>';
							 }

						 }else{
							 if (obj.appStatus == '1') {
								 //下载状态
//								 alert('下载');
								 statusUp = '<input type="hidden" id="' + obj.appId + 'state" value="1">' +
									 '<div class="appdown-box show-appdown" id="' + obj.appId + 'li"><a href="javascript:;" class="app-down">点击下载</a>' +
									 '<img src="images/app_new.png" class="app-new">' +
									 '</div>';
								 appStr += '<div class="app-col"><div class="app-box" ng-click="downloadOrUpdate('+ i +')"><div class="app-item">' +
									 '<p class="app-img"><img src="' + obj.icon + '" /><p><span class="app-name">' + obj.appName + '</span></div>' + statusUp +
								 '</div></div>';
							 }
						 }
						 angular.element(el).html('').append($compile(appStr)($scope));
					 })
				}


			}
		}, function () {
			$ionicLoading.show({
				template: '查询应用失败!'
			});
			$timeout(function () {
				$ionicLoading.hide();
			}, 1000);
		});

	} else {
		var appStr = "";
		var json = {
			"databaseName": "AppDatabase",
			"tableName": "app_info"
		}
		queryAllTableData(json, function (data) {
			$scope.$apply(function () {
				$scope.all_app = data;
				if (data.length > 0) {
					for (var i = 0; i < data.length; i++) {
						var picSrc = data[i].icon;
						appStr += "<div class='app-col'>" +
							"<div class='app-box' ng-click='downloadOrUpdate(" + i + ")'>" +
							"<div class='app-item'>" +
							"<p class='app-img'><img src='" + picSrc + "' /><p>" +
							"<span class='app-name'>" + data[i].name + "</span>" +
							"</div>" +
							"<input type='hidden' id='" + data[i].appId + "state' value='3'>" +
							"</div>" +
							"</div>";
					}
				}
				var txt = $compile(appStr)($scope);
				var el = document.getElementById("app-list-box");
				angular.element(el).html('').append(txt);
			});
		}, function () {
			alert('查询本地失败！');
		})
	}

}
//判断app的状态
function checkApp(i, d, appStr, $scope, $compile, $ionicLoading, $http, $ionicPopup, $timeout) {
	var obj = d[i];
	var json = {
		"databaseName": "AppDatabase",
		"tableName": "app_info",
		"conditions": {"appId": obj.appId}
	};
	queryTableDataByConditions(json, function (data) {
		// var picSrc="http://10.0.22.78:7003/emm_backend_static/appImages/001.png";
//		alert(typeof obj.appStatus)
		var picSrc = obj.icon;
		var statusUp = "";
		if (data.length > 0) {
			if (obj.appStatus == '1') {//已经关闭的 删除本地数据以及文件
				if (obj.versionId == data[0].versionId) {//直接打开状态
					statusUp = "<input type='hidden' id='" + obj.appId + "state' value='3'>";
				} else{//更新状态
					statusUp = "<input type='hidden' id='" + obj.appId + "state' value='2'>" +
						"<div class='appdown-box show-appdown' id='" + obj.appId + "li'>" +
						"<a href='javascript:;' class='app-down'>点击更新</a>" +
						"<img src='images/app_update.png' class='app-update'>" +
						"</div>";
				}
			} else {
				/*statusUp = "<input type='hidden' id='" + obj.appId + "state' value='4'>" +
					"<div class='appdown-box show-appdown' id='" + obj.appId + "li'>" +
					"<p class='appdown-des'>应用注销</p>" +
					"<a href='javascript:;' class='app-down'>点击卸载</a>" +
					"<img src='images/app_cancel.png' class='app-cancel'>" +
					"</div>";*/
			}
			appStr += "<div class='app-col'>" +
				"<div class='app-box' ng-click='downloadOrUpdate(" + i + ")'>" +
				"<div class='app-item'>" +
				"<p class='app-img'><img src='" + picSrc + "' /><p>" +
				"<span class='app-name'>" + obj.appName + "</span>" +
				"</div>" + statusUp +
				"</div>" +
				"</div>";
		}
		else {//下载状态
			if (obj.appStatus == '1') {
//				alert(obj.appId)
				statusUp = "<input type='hidden' id='" + obj.appId + "state' value='1'>" +
					"<div class='appdown-box show-appdown' id='" + obj.appId + "li'>" +
					"<a href='javascript:;' class='app-down'>点击下载</a>" +
					"<img src='images/app_new.png' class='app-new'>" +
					"</div>";

				appStr += "<div class='app-col'>" +
					"<div class='app-box' ng-click='downloadOrUpdate(" + i + ")'>" +
					"<div class='app-item'>" +
					"<p class='app-img'><img src='" + picSrc + "' /><p>" +
					"<span class='app-name'>" + obj.appName + "</span>" +
					"</div>" + statusUp +
					"</div>" +
					"</div>";
			}
		}
		if (i < d.length - 1) {
			i++;
			checkApp(i, d, appStr, $scope, $ionicLoading, $compile);
		} else {
			var txt = $compile(appStr)($scope);
			var el = document.getElementById("app-list-box");
			angular.element(el).html('').append(txt);
			//在线状态下自动下载更新
			var checked = eval("(" + storage.getItem('checked') + ")");
			checked = true;
			/*if(checked == true&&onDeviceReady()=='WiFi connection'){
			 var autoDown=0;
			 autoDownloadOrUpdate($scope,$http,$ionicPopup,$timeout,autoDown,d);
			 }*/

			appStr = "";
			i == 0;
		}
	}, function () {
		console.log("本地查询出错！")
	});
}
function autoDownloadOrUpdate($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d) {
	$scope.objData = $scope.all_app[autoDown];
	var state = document.getElementById($scope.objData.appId + "state").value;
	if ('1' == state || '2' == state) {//下载、更新
		autoDownloadApp($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d);
	}
	else {
		autoDown++;
		if (autoDown > d.length) return;
		autoDownloadOrUpdate($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d);//wifi自动下载
	}
}

//打开单频道应用
function openNativeApp(appid) {
	//根据频道ID查询菜单
	var serviceType = "LOCAL";
	var url = "promodel/" + appid + "/www/index.html?pctype=" + platform + "&proid=" + appid;
	var menuJson = {
		"databaseName": "AppDatabase",
		"tableName": "app_menu",
		"conditions": {
			"cmsmanage_channel_id": appid
		}
	};
	var jsonKey = {
		"serviceType": serviceType,
		"URL": url
	};
	pushToViewController(jsonKey, function () {
		console.log("成功！")
	}, function () {
		console.log("失败！")
	})
}
//wifi下自动下载应用
function autoDownloadApp($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d) {
	var jsonApp = {
		"databaseName": "AppDatabase",
		"tableName": "app_info",
		"conditions": [
			{"appId": $scope.objData.appId}
		],
		"data": [
			{
				"appId": $scope.objData.appId,
				"appsourceid": $scope.objData.appsourceid,
				"appstoreid": $scope.objData.appstoreid,
				"company": $scope.objData.company,
				"description": $scope.objData.description,
				"icon": $scope.objData.icon,
				"iconInfo": $scope.objData.iconInfo,
				"versionDescription": $scope.objData.versionDescription,
				"name": $scope.objData.appName,
				"pkgname": $scope.objData.pkgname,
				"fullTrialText": $scope.objData.fullTrialText,
				"version": $scope.objData.version,
				"versionId": $scope.objData.versionId,
				"ipaUrl": $scope.objData.ipaUrl,
				"full_trial_id": $scope.objData.full_trial_id,
				"version_type": $scope.objData.version_type,
				"schemesUrl": $scope.objData.schemesUrl,
				"service_type": $scope.objData.codeStyleText,
				"createTime": $scope.objData.createTime,
				"appSize": $scope.objData.appSize,
				"plistUrl": $scope.objData.plistUrl
			}
		]
	};

	//向本地库添加数据
	updateORInsertTableDataByConditions(jsonApp, function (str) {
		if (1 == str[0]) { //数据插入成功
			if ('NATIVE' == $scope.objData.codeStyleText) {
				var downloadUrl = "";
				if (brows().android) {
					downloadUrl = $scope.objData.ipaUrl;
				} else {
					downloadUrl = $scope.objData.plistUrl;
				}
				var appKye = {'appList': downloadUrl};
				downloadNavtiveApp(appKye, function (str) {
					if ('1' == str[0]) {
						document.getElementById($scope.objData.appId + "state").value = "3";
						document.getElementById($scope.objData.appId + "li").className = 'appdown-box';
						autoDown++;
						if (autoDown >= d.length) {
							alert('原生应用下载成功');
							return;
						}
						autoDownloadOrUpdate($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d);//wifi自动下载
					}
				}, function () {
					autoDown++;
					if (autoDown >= d.length) return;
					autoDownloadOrUpdate($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d);//wifi自动下载
					alert("原生应用下载失败！");
				})
			} else if ('SERVICE' == $scope.objData.codeStyleText) {
				document.getElementById($scope.objData.appId + "state").value = "3";
				document.getElementById($scope.objData.appId + "li").className = 'appdown-box';
				autoDown++;
				if (autoDown >= d.length) return;
				autoDownloadOrUpdate($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d);//wifi自动下载
			} else {//单应用
				//下载应用包
				var modelJson = {
					"package": "promodel/" + $scope.objData.appId,
					"url": $scope.objData.ipaUrl
				}
//        alert($scope.objData.ipaUrl);
				downloadZip(modelJson, function () {
					document.getElementById($scope.objData.appId + "li").className = 'appdown-box';
					document.getElementById($scope.objData.appId + "state").value = "3";
					// showPopup('应用资源下载成功',$scope,$ionicPopup,$timeout);
					// alert("应用资源下载成功！");
					autoDown++;
					if (autoDown >= d.length) {
//              alert('应用资源下载成功');
						$ionicLoading.show({
							template: '应用资源下载成功!'
						});
						$timeout(function () {
							$ionicLoading.hide();
						}, 1000);
						return;
					}
					autoDownloadOrUpdate($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d);//wifi自动下载
				}, function () {
					$ionicLoading.show({
						template: '应用资源下载出错!'
					});
					$timeout(function () {
						$ionicLoading.hide();
					}, 1000);
					autoDown++;
					if (autoDown >= d.length) return;
					autoDownloadOrUpdate($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d);//wifi自动下载
				});
			}
		} else {
			alert("数据插入失败！");
			autoDown++;
			if (autoDown >= d.length) return;
			autoDownloadOrUpdate($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d);//wifi自动下载
		}
	}, function () {
		autoDown++;
		if (autoDown >= d.length) return;
		autoDownloadOrUpdate($scope, $http, $ionicPopup, $ionicLoading, $timeout, autoDown, d);//wifi自动下载
		console.log("数据插入异常！");
	});
	return false;//取消冒泡
}
//下载应用
function downloadApp($scope, $http, $ionicPopup, $ionicLoading, $timeout) {

	if ('NATIVE' == $scope.objData.codeStyleText) {
		var downloadUrl = "";
		if (brows().android) {
			downloadUrl = $scope.objData.ipaUrl;
		} else {
			downloadUrl = $scope.objData.plistUrl;
		}
//		alert(downloadUrl);
		var appKye = {'appList': downloadUrl};
		downloadNavtiveApp(appKye, function (str) {
			if ('1' == str[0]) {
				document.getElementById($scope.objData.appId + "state").value = "3";
				document.getElementById($scope.objData.appId + "li").className = 'appdown-box';
//            alert("原生应用下载成功！");
				$ionicLoading.show({
					template: '应用下载成功!'
				});
				$timeout(function () {
					$ionicLoading.hide();
				}, 1000);
				//////////////
				addAppToTable($scope);
			}
		}, function () {
			alert("原生应用下载失败！");
		})
	} else if ('SERVICE' == $scope.objData.codeStyleText) {
		document.getElementById($scope.objData.appId + "state").value = "3";
		document.getElementById($scope.objData.appId + "li").className = 'appdown-box';
		alert('我是服务！');
	} else {//单应用
		//下载应用包
		var modelJson = {
			"package": "promodel/" + $scope.objData.appId,
			"url": $scope.objData.ipaUrl
		}
//        alert($scope.objData.ipaUrl);
		downloadZip(modelJson, function () {
			document.getElementById($scope.objData.appId + "li").className = 'appdown-box';
			document.getElementById($scope.objData.appId + "state").value = "3";
//          showPopup('应用下载成功',$scope,$ionicPopup,$timeout);
			$ionicLoading.show({
				template: '应用资源下载成功!'
			});
			$timeout(function () {
				$ionicLoading.hide();
			}, 1000);
			//////////////
			addAppToTable($scope);
		}, function () {
//			alert("应用下载失败！");
			$ionicLoading.show({
				template: '应用下载失败!'
			});
			$timeout(function () {
				$ionicLoading.hide();
			}, 1000);
		});
	}
}

/**
 * 将下载成功的应用存本地数据表
 * @param $scope
 */
function addAppToTable($scope) {
	var jsonApp = {
		"databaseName": "AppDatabase",
		"tableName": "app_info",
		"conditions": [
			{"appId": $scope.objData.appId}
		],
		"data": [
			{
				"appId": $scope.objData.appId,
				"appsourceid": $scope.objData.appsourceid,
				"appstoreid": $scope.objData.appstoreid,
				"company": $scope.objData.company,
				"description": $scope.objData.description,
				"icon": $scope.objData.icon,
				"iconInfo": $scope.objData.iconInfo,
				"versionDescription": $scope.objData.versionDescription,
				"name": $scope.objData.appName,
				"pkgname": $scope.objData.pkgname,
				"fullTrialText": $scope.objData.fullTrialText,
				"version": $scope.objData.version,
				"versionId": $scope.objData.versionId,
				"ipaUrl": $scope.objData.ipaUrl,
				"full_trial_id": $scope.objData.full_trial_id,
				"version_type": $scope.objData.version_type,
				"schemesUrl": $scope.objData.schemesUrl,
				"service_type": $scope.objData.codeStyleText,
				"createTime": $scope.objData.createTime,
				"appSize": $scope.objData.appSize,
				"plistUrl": $scope.objData.plistUrl
			}
		]
	};
	//向本地库添加数据
	updateORInsertTableDataByConditions(jsonApp, function (str) {
		if (str[0] == 1) {
			console.log("数据插入成功!");
		} else {
			console.log("数据插入失败！");
		}
	}, function () {
		console.log("数据插入异常！");
	});
}

//删除应用
function deleteAppFun($scope, $http, $compile, $ionicPopup, $ionicLoading, $timeout) {
	$ionicLoading.show({
		template: 'Loading...'
	})
	var json = {
		"databaseName": "AppDatabase",
		"tableName": "app_info",
		"conditions": [
			{"appId": $scope.objData.appId}
		]
	};
	deleteTableData(json, function (str) {
		if ('1' == str[0]) {
			if ('NATIVE' != $scope.objData.codeStyleText) {
				deleteFilePath("", function () {
					$ionicLoading.hide();
					alert("应用删除成功！");
					loadApp($scope, $http, $compile);
				}, function () {
					console.log('应用删除失败！');
				});
			}
		} else {
			alert("应用删除失败！");
		}
	}, function () {
		alert("失败");
	});
}
function showPopup(msg, $scope, $ionicPopup, $timeout) {
	// An elaborate, custom popup
	var myPopup = $ionicPopup.show({
		template: msg,
		scope: $scope
	});
	myPopup.then(function (res) {
		console.log('Tapped!', res);
	});
	$timeout(function () {
		myPopup.close(); //close the popup after 3 seconds for some reason
	}, 3000);
}
//是否在线
function onDeviceReady() {
	var networkState = navigator.connection.type;
	var states = {};
	states[Connection.UNKNOWN] = 'Unknown connection';
	states[Connection.ETHERNET] = 'Ethernet connection';
	states[Connection.WIFI] = 'WiFi connection';
	states[Connection.CELL_2G] = 'Cell 2G /Users/sushujuan/Downloads/www/js/plugin.jsconnection';
	states[Connection.CELL_3G] = 'Cell 3G connection';
	states[Connection.CELL_4G] = 'Cell 4G connection';
	states[Connection.CELL] = 'Cell generic connection';
	states[Connection.NONE] = 'No network connection';
	return states[networkState];
}


/**
 * 格式化时间
 * @param format
 * @returns {*}
 */
/*
 Date.prototype.format =function(format)
 {
 var o = {
 "M+" : this.getMonth()+1, //month
 "d+" : this.getDate(), //day
 "h+" : this.getHours(), //hour
 "m+" : this.getMinutes(), //minute
 "s+" : this.getSeconds() //second
 };
 if(/(y+)/.test(format)){
 format=format.replace(RegExp.$1,(this.getFullYear()+"").substr(4- RegExp.$1.length));

 }
 for(var k in o){
 if(new RegExp("("+ k +")").test(format)){
 format = format.replace(RegExp.$1,RegExp.$1.length==1? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
 }
 }
 return format;
 };
 */

