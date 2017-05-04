var menu = {
	'car': {
		title: '车辆销售分析',
		menu: [{
			title: '基本订单信息查询',
			icon: 'img/img2.png',
			href: 'OrderServlet?methods=showAllOrder',
			isCurrent: true
		},{
			title: '各店销售情况',
			icon: 'img/img2.png',
			href: 'OrderServlet?methods=showShopOrder'
		}]
	},

	'client': {
		title: '顾客分析',
		menu: [{
			title: '各车型冷热程度',
			icon: 'img/img4.png',
			href: 'project/userinfo.html',
			isCurrent: true
		},{
			title: '价格分析',
			icon: 'img/img4.png',
			href: 'project/plan.html'
		},{
			title: '客户信息来源',
			icon: 'img/img4.png',
			href: 'project/work_record.html'
		}]
	},

	'employee': {
		title: '绩效管理',
		menu: [{
			title: '4s点情况',
			icon: 'img/img4.png',
			isCurrent: true,
			href: 'query/work_situation_query.html'
		},{
			title: '店员情况',
			icon: 'img/img4.png',
			href: 'query/work_summary.html'
		}]
	}
};