## Doc & Courses

- https://www.kaggle.com/
- https://www.promptingguide.ai/
- https://www.youtube.com/@bycloudAI/videos 
- https://www.youtube.com/@aiDotEngineer/videos
- https://github.com/dair-ai/Mathematics-for-ML
- https://github.com/microsoft/ML-For-Beginners
- https://github.com/microsoft/mcp-for-beginners
- https://github.com/microsoft/generative-ai-for-beginners
- https://machinelearningmastery.com/python-machine-learning-mini-course/
- https://machinelearningmastery.com/machine-learning-algorithms-mini-course/
- https://github.com/ahmedbahaaeldin/From-0-to-Research-Scientist-resources-guide
- https://github.com/ZuzooVn/machine-learning-for-software-engineers?tab=readme-ov-file#interview-questions

#### Articles

- https://blog.csdn.net/nav/ai  
- https://lucumr.pocoo.org/2026/5/8/local-models/
- https://www.wheresyoured.at/make-fun-of-them/
- https://www.wheresyoured.at/the-era-of-the-business-idiot/
- https://www.dane.ac-versailles.fr/spip.php?article1167
- https://addxorrol.blogspot.com/2025/07/a-non-anthropomorphized-view-of-llms.html

![](./images/ml.png)
![](./images/formulas.png)

## Cheatsheets

- [Machine Learning cheatsheets for Stanford's CS 229](https://stanford.edu/~shervine/teaching/cs-229/)
- https://github.com/SuperCowPowers/data_hacking
- https://github.com/Trusted-AI/adversarial-robustness-toolbox

### Quantum Machine Learning

- https://qml-tutorial.github.io/

### Classification

- https://github.com/humphd/have-fun-with-machine-learning

### Clustering

- https://www.intercom.com/blog/machine-learning-way-easier-than-it-looks/

### DeepLearning

- https://blog.eleuther.ai/transformer-math/
- https://kipp.ly/transformer-inference-arithmetic/
- https://github.com/veekaybee/what_are_embeddings
- https://github.com/labmlai/annotated_deep_learning_paper_implementations
- https://medium.com/@alexandreluca23/building-yolo-your-guide-to-smarter-object-detection-6fce20f81e0a

#### GenAI & LLMs (Natural Language Processing)

- [Large Language Models as Markov Chains](https://arxiv.org/pdf/2410.02724)
- [On the biology of a Large Language Model](https://transformer-circuits.pub/2025/attribution-graphs/biology.html)
- https://robot9.me/write-gpt-from-scratch/
- https://github.com/rasbt/LLMs-from-scratch
- https://github.com/AlexBuz/llama-zip
- https://github.com/konrad-gajdus/miniMNIST-c
- https://www.deeplearning.ai/courses/generative-ai-with-llms/

**Leaderboards**

- https://lmarena.ai/leaderboard
- https://artificialanalysis.ai/leaderboards/models

#### Understanding / Building LLM applications

- https://github.com/microsoft/generative-ai-for-beginners/
- https://www.deeplearning.ai/short-courses/getting-started-with-mistral/
- https://cyber.gouv.fr/publications/recommandations-de-securite-pour-un-systeme-dia-generative


**Tensorflow (deprecated)**

- https://github.com/vahidk/EffectiveTensorflow
- https://github.com/hunkim/DeepLearningZeroToAll/

**PyTorch**

- https://github.com/Kaixhin/grokking-pytorch
- https://www.aime.info/blog/en/multi-gpu-pytorch-training/


## Challenges

- https://gandalf.lakera.ai/
- https://www.jailbreakchat.com/
- https://lakera-marketing-public.s3.eu-west-1.amazonaws.com/Lakera+AI+-+Real+World+LLM+Exploits+(Jan+2024).pdf

## Models and Usage

- [llama-cli.sh](./llama-cli.sh) / [llama-server.sh](./llama-server.sh) - local scripts, run a GGUF model (Qwen3.5-0.8B here) via [llama.cpp](https://github.com/ggml-org/llama.cpp)'s official Docker image (CLI vs. OpenAI-compatible HTTP server on :8080)
- https://huggingface.co/models - foss models for local inference
- https://colab.research.google.com/ - use nvidia gpus, required google account
- https://openrouter.ai/docs/quickstart - api , many providers, manage cost
- https://github.com/cheahjs/free-llm-api-resources/

### Agents

- https://docs.docker.com/guides/agentic-ai/

#### Sota

- https://opencode.ai/
- https://openclaw.ai/
- https://chatgpt.com/codex/
- https://code.claude.com/docs/
- https://hermes-agent.nousresearch.com/docs
- https://qwenlm.github.io/qwen-code-docs/en/cli/

#### Guides

- https://www.promptingguide.ai/research/llm-agents
- https://docs.langchain.com/oss/python/langchain/quickstart
- https://claude.com/blog/building-agents-with-the-claude-agent-sdk
- https://api-docs.deepseek.com/quick_start/agent_integrations/claude_code/
- https://andrewlock.net/running-ai-agents-safely-in-a-microvm-using-docker-sandbox/


```bash
sbx --help
sbx policy allow network --sandbox claude-bb api.deepseek.com
sbx exec claude-bb -it bash
# export ANTHROPIC_AUTH_TOKEN=<your DeepSeek API Key>
# claude

sbx secret set-custom claude-bb --host api.deepseek.com --env ANTHROPIC_AUTH_TOKEN
```

### Tools

#### MCP servers

- https://docs.openclaw.ai/cli/mcp
- https://developers.openai.com/codex/mcp
- https://code.claude.com/docs/en/mcp-quickstart
- https://github.com/punkpeye/awesome-mcp-clients
- https://github.com/FuzzingLabs/mcp-security-hub
- https://modelcontextprotocol.io/docs/tools/inspector

#### Native tools

#### Python

- https://www.tensorflow.org/install/docker
- https://cheatography.com/tetrisj/cheat-sheets/ipython/
- https://ipython.readthedocs.io/en/stable/interactive/magics.html/
- https://stackoverflow.com/questions/20327621/calling-ipython-from-a-virtualenv/

#### Browser

- https://worldview.ai/
- [Tensorflow Playground](https://playground.tensorflow.org/#activation=tanh&batchSize=10&dataset=circle&regDataset=reg-plane&learningRate=0.03&regularizationRate=0&noise=0&networkShape=4,2&seed=0.93066&showTestData=false&discretize=false&percTrainData=50&x=true&y=true&xTimesY=false&xSquared=false&ySquared=false&cosX=false&sinX=false&cosY=false&sinY=false&collectStats=false&problem=classification&initZero=false&hideText=false)


## Attacks

### Indirect Prompt Injection Threats

- https://greshake.github.io/
- [https://research.nccgroup.com/2022/12/05/exploring-prompt-injection-attacks/](https://web.archive.org/web/20230828221806/https://research.nccgroup.com/2022/12/05/exploring-prompt-injection-attacks/)
- [Ignore Previous Prompt: Attack Techniques For Language Models](https://arxiv.org/abs/2211.09527)
- https://jia.je/ctf-writeups/2025-09-05-imaginary-ctf-2025/tax-return.html # System prompt leak
- https://jia.je/ctf-writeups/2025-12-20-tsg-ctf-2025/chatbot.html          # Recover prompt from kv cache

#### Against GPT

- https://github.com/0xk1h0/ChatGPT_DAN
- https://github.com/asgeirtj/system_prompts_leaks
- https://simonwillison.net/2022/Sep/12/prompt-injection/


### Pickle file attacks

- https://blog.trailofbits.com/2024/06/11/exploiting-ml-models-with-pickle-file-attacks-part-1/
- https://blog.trailofbits.com/2022/10/03/semgrep-maching-learning-static-analysis/

### Adversarial Attacks

- https://tog.re/articles/conf_rm/
- https://tog.re/articles/asr_research/
- https://github.com/Trusted-AI/adversarial-robustness-toolbox

