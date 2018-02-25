// pages/home/home.js
var Bmob = require('../../utils/bmob.js');
var Util = require('../../utils/util.js');
var app = getApp()

Page({

  /**
   * 页面的初始数据
   */
  data: {
    isAdmin: false,
    banners: [],
    categories: [],
    messages: [],
    indicatorDots: true,
    autoplay: true,
    interval: 3000,
    duration: 1000
  },

  checkAdmin: function() {
    var that = this
    var User = Bmob.Object.extend("wh_user");
    var query = new Bmob.Query(User);
    query.equalTo("role", 1);
    query.find({
      success: function (results) {
        // 循环处理查询到的数据
        console.log(JSON.stringify(results))
        for (var i = 0; i < results.length; i++) {
          if (app.globalData.userInfo.nickName == results[i].get("nickName")) {
            that.setData({
              isAdmin: true
            })
            break
          }
        }
      },
      error: function (error) {
        console.log("查询失败: " + error.code + " " + error.message);
        Util.showErrorTip("查询失败: " + error.code + " " + error.message)
      }
    });
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var that = this

    if (app.globalData.userInfo) {
      that.checkAdmin()
    } else {
      wx.getUserInfo({
        success: res => {
          app.globalData.userInfo = res.userInfo
          wx.setStorageSync('userInfo', res.userInfo)
          that.existed(res.userInfo)
        }
      })
    }

    var Banner = Bmob.Object.extend("Banner");
    var query = new Bmob.Query(Banner);

    Util.showLoadingDialog()
    query.find({
      success: function (results) {
        Util.hideLoadingDialog()
        // 循环处理查询到的数据
        console.log(JSON.stringify(results))
        var banners = []
        for (var i = 0; i < results.length; i++) {
          var item = results[i]
          banners.push(item.get("img")._url)
        }
        that.setData({
          banners: banners
        })
      },
      error: function (error) {
        Util.hideLoadingDialog()
        console.log("查询失败: " + error.code + " " + error.message);
        Util.showErrorTip("查询失败: " + error.code + " " + error.message)
      }
    });

    var Category = Bmob.Object.extend("Category");
    var query = new Bmob.Query(Category);
    query.ascending("number");
    query.find({
      success: function (results) {
        // 循环处理查询到的数据
        console.log(JSON.stringify(results))
        var categories = []
        for (var i = 0; i < results.length; i++) {
          var item = results[i]
          var category = {}
          category.title = item.get("title")
          category.number = item.get("number")
          category.imgUrl = item.get("img")._url
          categories.push(category)
        }
        that.setData({
          categories: categories
        })
      },
      error: function (error) {
        console.log("查询失败: " + error.code + " " + error.message);
        Util.showErrorTip("查询失败: " + error.code + " " + error.message)
      }
    });

    var Message = Bmob.Object.extend("Message");
    var query = new Bmob.Query(Message);
    query.limit(15);
    query.descending("createdAt");
    query.find({
      success: function (results) {
        // console.log(JSON.stringify(results))
        var messages = []
        for (var i = 0; i < results.length; i++) {
          var item = results[i]
          var message = {}
          message.title = item.get("title")
          message.content = item.get("content")
          message.avatarUrl = item.get("avatarUrl")
          message.publisher = item.get("publisher")
          message.images = item.get("images")
          if (message.images && message.images.length > 3) {
            message.imageText = message.images.length - 3
          }
          message.id = item.id
          message.date = item.createdAt
          
          messages.push(message)
        }
        that.setData({
          messages: messages
        })
      },
      error: function (error) {
        console.log("查询失败: " + error.code + " " + error.message);
        Util.showErrorTip("查询失败: " + error.code + " " + error.message)
      }
    });
  },

  existed: function(userInfo) {
    var that = this
    var User = Bmob.Object.extend("wh_user");
    var query = new Bmob.Query(User);
    query.equalTo("nickName", userInfo.nickName);
    query.find({
      success: function (results) {
        // 循环处理查询到的数据
        if (results.length <= 0) {
          that.saveUser(userInfo)
        } else {
          that.checkAdmin()
        }
      },
      error: function (error) {
        that.checkAdmin()
        console.log("existed 查询失败: " + error.code + " " + error.message);
      }
    });
  },

  saveUser: function(userInfo) {
    var that = this
    var User = Bmob.Object.extend("wh_user");
    var user = new User();
    user.set("avatarUrl", userInfo.avatarUrl);
    user.set("city", userInfo.city);
    user.set("gender", userInfo.gender);
    user.set("nickName", userInfo.nickName);
    user.set("province", userInfo.province);
    user.set("country", userInfo.country);
    var role = (userInfo.nickName == "范兴松" || userInfo.nickName == "沈阳万合学校 李主任") ? 1 : 0
    user.set("role", role);

    user.save(null, {
      success: function (result) {
        console.log('🌹🌹🌹wh_user save: ' + JSON.stringify(result))
        that.checkAdmin()
      },
      error: function (result, error) {
        // 添加失败
        console.log(error)
      }
    });
  },

  writeBtn: function(e) {
    wx.navigateTo({
      url: '../write/write',
    })
  },

  messageBtn: function (e) {
    wx.navigateTo({
      url: '../message/message',
    })
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
  
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
  
  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
  
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
  
  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {
  
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {
  
  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
  
  }
})