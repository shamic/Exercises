// pages/comment/comment.js

var app = getApp()
var Bmob = require("../../utils/bmob.js");
var Util = require('../../utils/util.js');

var that

Page({

  /**
   * 页面的初始数据
   */
  data: {
    isLoading: false,
    isdisabled: false,
    formInfo: ""
  },

  commit: function (e) {

    var content = e.detail.value.content.trim();
    var title = e.detail.value.title.trim();
    var phone = e.detail.value.phone.trim();

    if (content == "" || title == "" || phone == "") {
      Util.showErrorTip("填写的姓名/手机号/留言内容不能为空")
    } else {
      that.setData({
        isLoading: true,
        isdisabled: true
      })
      var Comment = Bmob.Object.extend("Comment");
      var comment = new Comment();
      comment.set("name", title);
      comment.set("comment", content);
      comment.set("phone", phone);
      if (app.globalData.userInfo) {
        comment.set("wx_name", app.globalData.userInfo.nickName)
      }
      
      comment.save(null, {
        success: function (result) {
          that.setData({
            isLoading: false,
            isdisabled: false,
            formInfo: ""
          })
          wx.showToast({
            title: '提交成功',
            icon: "success"
          })
        },
        error: function (result, error) {
          // 添加失败
          console.log(error)
          wx.showToast({
            title: '提交失败',
            icon: "none"
          })
          that.setData({
            isLoading: false,
            isdisabled: false
          })

        }
      });
    }

  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    that = this
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