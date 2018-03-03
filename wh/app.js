//app.js
var Bmob = require('utils/bmob.js');
// Bmob.initialize("28d50890c51c4f0120b96351755d1c11", "93c97fbf0305c4db613bc9ee515c1b8c");
Bmob.initialize("5d138214843983b024ef2488bb9ac47b", "ea2181f1d144ac7c4e2de5b9abdaa33e");

App({
  onLaunch: function () {
    // 展示本地存储能力
    var userInfo = wx.getStorageSync('userInfo') || null

    if (userInfo != null) {
      this.globalData.userInfo = userInfo
    }
  },

  globalData: {
    userInfo: null
  }
})