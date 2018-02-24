// pages/write/write.js

var app = getApp()
var Bmob = require("../../utils/bmob.js");

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
    loading: true,
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

    console.log(content)

    if (content == "") {
      // common.dataLoading("心情内容不能为空", "loading");
    }
    else {
      that.setData({
        isLoading: true,
        isdisabled: true
      })
      // wx.getStorage({
      //   key: 'user_id',
      //   success: function (ress) {
      //     var Diary = Bmob.Object.extend("Diary");
      //     var diary = new Diary();
      //     var me = new Bmob.User();
      //     me.id = ress.data;
      //     diary.set("title", title);
      //     diary.set("content", content);
      //     diary.set("is_hide", that.data.ishide);
      //     diary.set("publisher", me);
      //     diary.set("likeNum", 0);
      //     diary.set("commentNum", 0);
      //     diary.set("liker", []);
      //     if (that.data.isSrc == true) {
      //       var name = that.data.src;//上传的图片的别名
      //       var file = new Bmob.File(name, that.data.src);
      //       file.save();
      //       diary.set("pic", file);
      //     }
      //     diary.save(null, {
      //       success: function (result) {
      //         that.setData({
      //           isLoading: false,
      //           isdisabled: false
      //         })
      //         // 添加成功，返回成功之后的objectId（注意：返回的属性名字是id，不是objectId），你还可以在Bmob的Web管理后台看到对应的数据
      //         common.dataLoading("发布心情成功", "success", function () {
      //           wx.navigateBack({
      //             delta: 1
      //           })
      //         });
      //       },
      //       error: function (result, error) {
      //         // 添加失败
      //         console.log(error)
      //         common.dataLoading("发布心情失败", "loading");
      //         that.setData({
      //           isLoading: false,
      //           isdisabled: false
      //         })

      //       }
      //     });


      //   }
      // })


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