import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MonitorBrightnessApp());
class MonitorBrightnessApp extends StatelessWidget {
  const MonitorBrightnessApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(title: '显示器亮度调节', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.amber, useMaterial3: true, brightness: Brightness.light),
    darkTheme: ThemeData(colorSchemeSeed: Colors.amber, useMaterial3: true, brightness: Brightness.dark),
    home: const BrightnessHomePage());
}

class Monitor {
  String name, model;
  double brightness, contrast;
  Monitor({required this.name, required this.model, this.brightness = 0.7, this.contrast = 0.5});
}

class BrightnessHomePage extends StatefulWidget {
  const BrightnessHomePage({super.key});
  @override
  State<BrightnessHomePage> setState() => _BrightnessHomePageState();
}

class _BrightnessHomePageState extends State<BrightnessHomePage> {
  List<Monitor> _monitors = [
    Monitor(name: '内置显示器', model: 'MacBook Pro 14"'),
    Monitor(name: '外接显示器', model: 'Dell U2723QE'),
  ];
  bool _nightMode = false;
  double _colorTemp = 0.5;
  bool _autoBrightness = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🔆 显示器亮度'), centerTitle: true, actions: [
        IconButton(icon: Icon(_nightMode ? Icons.nightlight : Icons.wb_sunny, color: _nightMode ? Colors.amber : null), onPressed: () => setState(() => _nightMode = !_nightMode), tooltip: '夜间模式'),
      ]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
        // 显示器列表
        ..._monitors.asMap().entries.map((entry) => Card(margin: const EdgeInsets.only(bottom: 16), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(entry.key == 0 ? Icons.laptop : Icons.desktop_windows, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(entry.value.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(entry.value.model, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ])),
          ]),
          const SizedBox(height: 16),
          Row(children: [const Icon(Icons.brightness_6, size: 20), const SizedBox(width: 8), const Text('亮度'), const Spacer(), Text('${(entry.value.brightness * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold))]),
          Slider(value: entry.value.brightness, onChanged: (v) => setState(() => entry.value.brightness = v), activeColor: Colors.amber),
          Row(children: [const Icon(Icons.contrast, size: 20), const SizedBox(width: 8), const Text('对比度'), const Spacer(), Text('${(entry.value.contrast * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold))]),
          Slider(value: entry.value.contrast, onChanged: (v) => setState(() => entry.value.contrast = v), activeColor: Colors.orange),
        ])))),
        const SizedBox(height: 8),
        // 夜间模式设置
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('显示设置', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SwitchListTile(title: const Text('夜间模式'), subtitle: const Text('减少蓝光，保护眼睛'), value: _nightMode, onChanged: (v) => setState(() => _nightMode = v), secondary: const Icon(Icons.nightlight, color: Colors.amber), contentPadding: EdgeInsets.zero),
          if (_nightMode) ...[Row(children: [const Text('色温'), const Spacer(), Text(_colorTemp < 0.3 ? '冷色' : _colorTemp < 0.7 ? '中性' : '暖色', style: const TextStyle(color: Colors.amber))]), Slider(value: _colorTemp, onChanged: (v) => setState(() => _colorTemp = v), activeColor: Colors.amber)],
          SwitchListTile(title: const Text('自动亮度'), subtitle: const Text('根据环境光自动调节'), value: _autoBrightness, onChanged: (v) => setState(() => _autoBrightness = v), secondary: const Icon(Icons.brightness_auto), contentPadding: EdgeInsets.zero),
        ]))),
        const SizedBox(height: 16),
        // 快捷操作
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('快捷操作', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _buildQuickAction(Icons.brightness_low, '最低', 0.1),
            _buildQuickAction(Icons.brightness_medium, '适中', 0.5),
            _buildQuickAction(Icons.brightness_high, '最高', 1.0),
            _buildQuickAction(Icons.brightness_auto, '自动', 0.7),
          ]),
        ]))),
      ])),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, double value) {
    return GestureDetector(onTap: () => setState(() { for (var m in _monitors) { m.brightness = value; } }), child: Column(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.amber)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]));
  }
}
