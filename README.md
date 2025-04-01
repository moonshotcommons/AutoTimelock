# AutoTimelock 自动化执行合约

自动定时执行 Stylus 合约的 Chainlink Automation 合约。

## 开发环境配置

### 1. 安装依赖
```bash
# 安装 Chainlink 工具包
forge install smartcontractkit/foundry-chainlink-toolkit --no-commit
```

### 2. 配置 foundry.toml
添加以下重映射：
```toml
remappings = ['@chainlink/contracts=lib/foundry-chainlink-toolkit/lib/chainlink-brownie-contracts/contracts/']
```

### 3. 环境变量设置
```bash
# 账户地址
export ARB_DEMO=0x6c49d46cf7267A3De0A698cab95792BF69c91aFC
# 部署账户私钥
export PRIVATE_KEY=0x.....
# Arbitrum Sepolia RPC
export ARB_RPC=https://sepolia-rollup.arbitrum.io/rpc
export ETHERSCAN_API_KEY=...
```

## 部署流程

### 1. 部署合约
```bash
# 部署 AutoTimelock 合约，构造参数为 Stylus 合约地址
forge create \
    --rpc-url $ARB_RPC \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify \
    --etherscan-api-key $ETHERSCAN_API_KEY \
    src/AutoTimelock.sol:AutoTimelock \
    --constructor-args 0xF54C5b9c05C2dE971f427056Ae4a6e0f1b745D66

forge create --rpc-url $ARB_RPC --private-key $PRIVATE_KEY --broadcast  --verify --etherscan-api-key $ETHERSCAN_API_KEY src/AutoTimelock.sol:AutoTimelock --constructor-args 0xF54C5b9c05C2dE971f427056Ae4a6e0f1b745D66
```

### 2. 设置部署后的合约地址
```bash
export AUTOTL=0xc49d73f655b84680485d68aA540a675A653d1a3d
```

### 3. 测试自动化功能
```bash
# 验证 checkUpkeep 函数
cast abi-decode "checkUpkeep(bytes) returns (bool,bytes)" \
    $(cast call $AUTOTL "checkUpkeep(bytes)" 0x --rpc-url $ARB_RPC)

# 手动调用
cast send $AUTOTL "performUpkeep(bytes)" 0x --rpc-url $ARB_RPC --private-key $PRIVATE_KEY
```

## Chainlink Automation 注册

1. 访问 [Chainlink Automation](https://automation.chain.link/arbitrum-sepolia) 注册合约
2. 在 [Chainlink Faucet](https://faucets.chain.link/arbitrum-sepolia) 获取测试用 LINK 代币
