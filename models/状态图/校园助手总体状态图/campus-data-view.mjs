export const title = "同济校园助手总体状态图";

const documentStates = {
  Waiting: "公开指南与公告",
  Review: "已提取，待审核",
  Published: "发布到校园信息和问答",
};

const accessStates = {
  CampusWeb: "校园 Web",
  PublicInfo: "浏览已确认的信息",
  SignedIn: "已登录，可以提问",
  Answer: "按证据回答并附来源",
};

export function state({ document, calendar, library, access }) {
  return {
    "公开资料": documentStates[document.phase],
    "同济校历": calendar.dayType === "Unknown"
      ? "按日期查询"
      : "返回工作日、周末或假期",
    "图书馆实时余座": library.queried
      ? "可预约座位数及采样时间"
      : library.authorized
        ? "已授权，可以实时查询"
        : "待授权，首版展示开放时间和官方预约入口",
    "校园信息与问答": accessStates[access.page],
  };
}

const actions = {
  SyncPublicSources: "定时同步和解析",
  PublishReviewedContent: "审核通过",
  ReadCalendarAPI: "调用同济校历 API",
  ConfirmSeatAccess: "确认接口及授权",
  ReadLiveSeats: "查询官方余座数据",
  BrowsePublicInfo: "访客打开校园信息",
  SignIn: "校园统一认证",
  AskAgent: "Agent 检索资料并调用模型",
  Done: "等待下一次查询或同步",
};

export const step = (action) => actions[action];
