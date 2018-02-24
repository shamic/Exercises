const formatTime = date => {
  const year = date.getFullYear()
  const month = date.getMonth() + 1
  const day = date.getDate()
  const hour = date.getHours()
  const minute = date.getMinutes()
  const second = date.getSeconds()

  return [year, month, day].map(formatNumber).join('/') + ' ' + [hour, minute, second].map(formatNumber).join(':')
}

const formatNumber = n => {
  n = n.toString()
  return n[1] ? n : '0' + n
}

var canUseWxLoading = true
//加载对话框的显示和隐藏
function showLoadingDialog() {
  try {
    if (wx.canIUse('showLoading')) {
      canUseWxLoading = true;
    } else {
      canUseWxLoading = false;
    }
  } catch (e) {
    canUseWxLoading = false;
  }
  if (canUseWxLoading) {
    wx.showLoading({
      title: "加载中",
      mask: true
    });
  } else {
    wx.showToast({
      title: "加载中",
      icon: 'loading',
      mask: true,
      duration: 60000
    });
  }

}

function hideLoadingDialog() {
  if (canUseWxLoading) {
    wx.hideLoading();
  } else {
    wx.hideToast();
  }
}

function showErrorTip(content) {
  wx.showModal({
    title: '提示',
    content: content,
    showCancel: false,
    success: function (res) {
    }
  })
}

module.exports = {
  formatTime: formatTime,
  showLoadingDialog: showLoadingDialog,
  hideLoadingDialog: hideLoadingDialog,
  showErrorTip: showErrorTip
}
