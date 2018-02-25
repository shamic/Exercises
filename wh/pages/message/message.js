// pages/message/message.js

var Bmob = require('../../utils/bmob.js');
var Util = require('../../utils/util.js');
var app = getApp()
var that

Page({

  /**
   * 页面的初始数据
   */
  data: {
    comments: []
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    that = this
    var Comment = Bmob.Object.extend("Comment");
    var query = new Bmob.Query(Comment);
    query.limit(15);
    query.descending("createdAt");
    query.find({
      success: function (results) {
        var comments = []
        for (var i = 0; i < results.length; i++) {
          var item = results[i]
          var comment = {}
          comment.name = item.get("name")
          comment.comment = item.get("comment")
          comment.wx_name = item.get("wx_name") ? item.get("wx_name") : "未授权获取"
          comment.phone = item.get("phone")
          comment.id = item.id
          comment.date = item.createdAt

          comments.push(comment)
        }
        that.setData({
          comments: comments
        })
      },
      error: function (error) {
        console.log("查询失败: " + error.code + " " + error.message);
        Util.showErrorTip("查询失败: " + error.code + " " + error.message)
      }
    });
  },

  callPhone: function (e) {
    var index = e.currentTarget.dataset.id;
    var phone = this.data.comments[index].phone
    wx.makePhoneCall({
      phoneNumber: phone,
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