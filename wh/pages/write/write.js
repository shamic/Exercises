// pages/write/write.js

var app = getApp()
var Bmob = require("../../utils/bmob.js");
var Util = require('../../utils/util.js');

var that
Page({

  /**
   * 页面的初始数据
   */
  data: {
    src: "",
    isSrc: false,
    ishide: "0",
    autoFocus: true,
    isLoading: false,
    isdisabled: false,
    images: []
  },

  uploadPic: function () {//选择图标
    wx.chooseImage({
      count: 1, // 默认9
      sizeType: ['original', 'compressed'],
      sourceType: ['album', 'camera'], // 可以指定来源是相册还是相机，默认二者都有
      success: function (res) {
        // 返回选定照片的本地文件路径列表，tempFilePath可以作为img标签的src属性显示图片
        var tempFilePaths = res.tempFilePaths
        var images = that.data.images
        images.push(tempFilePaths[0])
        that.setData({
          isSrc: true,
          src: tempFilePaths,
          images: images
        })
      }
    })
  },
  clearPic: function (e) {//删除图片
    var item = e.currentTarget.dataset.id;
    var images = that.data.images
    for (var i = 0; i < images.length; i++) {
      if (images[i] == item) {
        images.splice(i, 1)
        break
      }
    }
    that.setData({
      isSrc: false,
      src: "",
      images: images
    })
  },
  changePublic: function (e) {//switch开关
    console.log(e.detail.value)
    if (e.detail.value == true) {
      wx.showModal({
        title: '信息发布',
        content: '确定发布？',
        showCancel: true,
        confirmColor: "#a07c52",
        cancelColor: "#646464",
        success: function (res) {
          if (res.confirm) {
            that.setData({
              ishide: "1"
            })
          }
          else {
            that.setData({
              isPublic: true
            })
          }
        }
      })

    }
    else {
      wx.showModal({
        title: '取消发布',
        content: '确定取消发布？',
        showCancel: true,
        confirmColor: "#a07c52",
        cancelColor: "#646464",
        success: function (res) {
          if (res.confirm) {
            that.setData({
              ishide: "0"
            })
          }
          else {
            that.setData({
              isPublic: false
            })
          }
        }
      })

    }
  },
  sendNewMood: function (e) {

    var content = e.detail.value.content;
    var title = e.detail.value.title;

    if (content == "") {
      Util.showErrorTip("发布内容不能为空")
    } else {
      that.setData({
        isLoading: true,
        isdisabled: true
      })

      var Message = Bmob.Object.extend("Message");
      var message = new Message();
      message.set("title", title);
      message.set("content", content);
      message.set("publisher", app.globalData.userInfo.nickName);
      message.set("avatarUrl", app.globalData.userInfo.avatarUrl);
      // message.set("likeNum", 0);
      // message.set("commentNum", 0);
      // message.set("liker", []);
      if (that.data.images.length > 0) {
        // 图片
        Util.showLoadingDialog()
        var urlArr = new Array();
        var tempFilePaths = that.data.images;
        var imgLength = tempFilePaths.length;
        if (imgLength > 0) {
          var newDate = new Date();
          var newDateStr = newDate.toLocaleDateString();

          var j = 0;
          //如果想顺序变更，可以for (var i = imgLength; i > 0; i--)
          for (var i = 0; i < imgLength; i++) {
            var tempFilePath = [tempFilePaths[i]];
            var extension = /\.([^.]*)$/.exec(tempFilePath[0]);
            if (extension) {
              extension = extension[1].toLowerCase();
            }
            var name = newDateStr + "." + extension;//上传的图片的别名

            var file = new Bmob.File(name, tempFilePath);
            file.save().then(function (res) {
              var url = res.url();
              console.log("第" + i + "张Url" + url);

              urlArr.push({ "url": url });
              j++;
              console.log(j, imgLength);
              if (imgLength == j) {
                console.log('images update done: ' + JSON.stringify(urlArr));
                message.set("images", urlArr)
                message.save(null, {
                  success: function (result) {
                    Util.hideLoadingDialog()
                    that.setData({
                      isLoading: false,
                      isdisabled: false
                    })
                    wx.showModal({
                      title: '提示',
                      content: '发布成功',
                      showCancel: false,
                      success: function (res) {
                        wx.navigateBack({

                        })
                      }
                    })
                  },
                  error: function (result, error) {
                    Util.hideLoadingDialog()
                    // 添加失败
                    console.log(error)
                    Util.showErrorTip("sendNewMood查询失败: " + JSON.stringify(error))
                    that.setData({
                      isLoading: false,
                      isdisabled: false
                    })
                  }
                });
              }
            }, function (error) {
              console.log('save images fail: ' + error)
            });

          }
        }
      } else {
        message.save(null, {
          success: function (result) {
            that.setData({
              isLoading: false,
              isdisabled: false
            })
            wx.showModal({
              title: '提示',
              content: '发布成功',
              showCancel: false,
              success: function (res) {
                wx.navigateBack({

                })
              }
            })
          },
          error: function (result, error) {
            // 添加失败
            console.log(error)
            Util.showErrorTip("sendNewMood查询失败: " + JSON.stringify(error))
            that.setData({
              isLoading: false,
              isdisabled: false
            })
          }
        });
      }
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