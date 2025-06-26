import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:candlesticks/candlesticks.dart';
import '../../bloc/trade/trade_bloc.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  bool isChartExpanded = true;
  String selectedTimeframe = '1分';
  List<String> timeframes = ['1秒', '30秒', '1分', '1时', '更多'];

  // 模拟K线数据
  List<Candle> candles = [];

  @override
  void initState() {
    super.initState();
    _generateSampleData();
    // 加载交易数据
    context.read<TradeBloc>().add(LoadTradeData());
  }

  void _generateSampleData() {
    final now = DateTime.now();
    candles = List.generate(60, (index) {
      // 基于原图的价格范围 9.06-9.19
      final basePrice = 9.08 + (index * 0.002) - 0.06; // 创建更自然的波动
      final volatility = 0.01; // 增加波动性
      final trend = (index / 60.0) * 0.08; // 轻微向上趋势

      final open = basePrice + trend + (index % 7 * 0.003) - 0.01;
      final closeChange = (index % 5 == 0
          ? 0.005
          : index % 3 == 0
              ? -0.003
              : 0.001);
      final close = open + closeChange;

      final high =
          [open, close].reduce((a, b) => a > b ? a : b) + (volatility * 0.5);
      final low =
          [open, close].reduce((a, b) => a < b ? a : b) - (volatility * 0.3);

      // 确保价格在合理范围内
      final finalHigh = high.clamp(9.06, 9.19);
      final finalLow = low.clamp(9.06, 9.19);
      final finalOpen = open.clamp(9.06, 9.19);
      final finalClose = close.clamp(9.06, 9.19);

      return Candle(
        date: now.subtract(Duration(minutes: 60 - index)),
        high: finalHigh,
        low: finalLow,
        open: finalOpen,
        close: finalClose,
        volume: 800 + (index * 50).toDouble() + (index % 10 * 200), // 更真实的成交量
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTokenHeader(),
            _buildChartSection(),
            // 交易控制区域
            _buildTradeControlSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 代币图标和名称
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1a1a),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    'T',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'TRUMP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF666666),
                size: 20,
              ),
            ],
          ),
          const SizedBox(width: 16),
          // 价格信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '\$9.0627',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const Text(
                  '-2.14%',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF4444),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // 右侧操作图标
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.sync_alt,
              color: Color(0xFF666666),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Column(
      children: [
        // 图表标题栏
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text(
                '图表',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChartExpanded = !isChartExpanded;
                  });
                },
                child: Icon(
                  isChartExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF666666),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        if (isChartExpanded) ...[
          const SizedBox(height: 16),
          // 时间周期选择
          _buildTimeframeSelector(),
          const SizedBox(height: 16),
          // K线图
          _buildCandlestickChart(),
        ],
      ],
    );
  }

  Widget _buildTimeframeSelector() {
    return Container(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: timeframes.map((timeframe) {
            bool isSelected = selectedTimeframe == timeframe;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTimeframe = timeframe;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeframe,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF333333)
                            : const Color(0xFF999999),
                      ),
                    ),
                    if (timeframe == '更多') ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: isSelected
                            ? const Color(0xFF333333)
                            : const Color(0xFF999999),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCandlestickChart() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0), // 去除圆角，更贴近原图
      ),
      child: Candlesticks(
        candles: candles,
        onLoadMoreCandles: () async {
          // 模拟加载更多数据
          await Future.delayed(const Duration(seconds: 1));
          final moreCandles = List.generate(20, (index) {
            final basePrice = 9.06;
            final random = (index * 0.001) - 0.01;
            final open = basePrice + random;
            final close = open + (index % 2 == 0 ? 0.003 : -0.002);
            final high = [open, close].reduce((a, b) => a > b ? a : b) + 0.001;
            final low = [open, close].reduce((a, b) => a < b ? a : b) - 0.001;

            return Candle(
              date: candles.first.date.subtract(Duration(minutes: index + 1)),
              high: high,
              low: low,
              open: open,
              close: close,
              volume: 1000 + (index * 100).toDouble(),
            );
          });

          setState(() {
            candles.insertAll(0, moreCandles);
          });
        },
        actions: [
          ToolBarAction(
            onPressed: () {
              setState(() {
                _generateSampleData();
              });
            },
            child: const Icon(
              Icons.refresh,
              color: Color(0xFF999999),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradeControlSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧交易表单
            Expanded(
              flex: 2,
              child: _buildTradeForm(),
            ),
            const SizedBox(width: 16),
            // 右侧价格列表
            Expanded(
              flex: 1,
              child: _buildPriceList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 买入/卖出选择 + 市值
        _buildTradeTypeSelector(),
        const SizedBox(height: 16),
        // 交易模式
        _buildTradeMode(),
        const SizedBox(height: 16),
        // 后续添加其他表单内容...
        const Expanded(
          child: Center(
            child: Text(
              '交易表单其他部分\n（待实现）',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTradeTypeSelector() {
    return Column(
      children: [
        // 买入/卖出 + P1 + 当前市值
        Row(
          children: [
            // 买入按钮
            GestureDetector(
              onTap: () {
                // 选择买入
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C851),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '买入',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 卖出按钮
            GestureDetector(
              onTap: () {
                // 选择卖出
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  '卖出',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF999999),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // P1下拉
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'P1',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down,
                      size: 16, color: Color(0xFF666666)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // 目标图标
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.adjust,
                size: 16,
                color: Color(0xFF666666),
              ),
            ),
            const Spacer(),
            // 当前市值
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  '当前市值',
                  style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                ),
                const SizedBox(height: 2),
                const Text(
                  '\$ 9.06B',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTradeMode() {
    return Row(
      children: [
        // 立即买入
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '立即买入',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // 抄底
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            '抄底',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xFF999999),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceList() {
    // 模拟实时价格数据
    final List<Map<String, dynamic>> priceData = [
      {'price': '9.0856', 'quantity': '1.58'},
      {'price': '9.082', 'quantity': '1.05'},
      {'price': '9.0829', 'quantity': '0.107'},
      {'price': '9.188', 'quantity': '0.0415'},
      {'price': '9.0785', 'quantity': '0.656'},
      {'price': '9.0659', 'quantity': '0.512'},
      {'price': '9.0756', 'quantity': '0.799'},
      {'price': '9.0866', 'quantity': '98.05'},
      {'price': '9.0815', 'quantity': '0.02'},
      {'price': '9.1911', 'quantity': '0.0415'},
      {'price': '9.087', 'quantity': '0.609'},
      {'price': '--', 'quantity': '0.244'},
      {'price': '9.0627', 'quantity': '0.244'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 价格列表标题
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '价格 ⊙ USD',
              style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
            ),
            Text(
              '数量',
              style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 价格列表
        Expanded(
          child: ListView.builder(
            itemCount: priceData.length,
            itemBuilder: (context, index) {
              final data = priceData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${data['price']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00C851),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      data['quantity'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // 全部按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '全部',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_up,
                size: 16, color: Color(0xFF333333)),
          ],
        ),
      ],
    );
  }
}
