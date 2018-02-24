// pages/detail/detail.js
var Bmob = require('../../utils/bmob.js');

Page({

  /**
   * 页面的初始数据
   */
  data: {
    banners: []
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var that = this
    var Banner = Bmob.Object.extend("Banner");
    var query = new Bmob.Query(Banner);

    query.find({
      success: function (results) {
        // 循环处理查询到的数据
        console.log(JSON.stringify(results))
        var banners = []
        for (var i = 0; i < results.length; i++) {
          var item = results[i]
          banners.push(item.attributes.img.url)
        }
        that.setData({
          banners: banners
        })
      },
      error: function (error) {
        console.log("查询失败: " + error.code + " " + error.message);
      }
    });
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