// pages/introduction/introduction.js

var Bmob = require('../../utils/bmob.js');
var Util = require('../../utils/util.js');

Page({

  /**
   * 页面的初始数据
   */
  data: {
    article: {}
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var that = this
    var num = options.number

    var Category = Bmob.Object.extend("Category");
    var query = new Bmob.Query(Category);
    query.equalTo("number", parseInt(num));
    query.find({
      success: function (results) {
        // 循环处理查询到的数据
        console.log(JSON.stringify(results))
        if (results.length > 0) {
          var item = results[0]
          var article = {}
          article.title = item.get("title") ? item.get("title") : null
          article.topImage = item.get("topImage") ? item.get("topImage")._url : null
          article.topContent = item.get("topContent") ? item.get("topContent") : null
          article.centerImage = item.get("centerImage") ? item.get("centerImage")._url : null
          article.centerContent = item.get("centerContent") ? item.get("centerContent") : null
          article.bottomImage = item.get("bottomImage") ? item.get("bottomImage")._url : null
          article.bottomContent = item.get("bottomContent") ? item.get("bottomContent") : null

          that.setData({
            article: article
          })
        }
      },
      error: function (error) {
        console.log("查询失败: " + error.code + " " + error.message);
        Util.showErrorTip("查询失败: " + error.code + " " + error.message)
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