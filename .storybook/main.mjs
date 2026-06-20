/** @type { import('@storybook/react-webpack5').StorybookConfig } */
const config = {
  stories: [
    "../stories/**/*.mdx",
    "../stories/**/*.stories.@(js|jsx|mjs|ts|tsx)",
    "../frontend/**/*.stories.@(js|jsx)",
  ],
  addons: [
    "@storybook/addon-webpack5-compiler-swc",
    "@storybook/addon-a11y",
    "@storybook/addon-docs",
    "@storybook/addon-onboarding",
  ],
  framework: "@storybook/react-webpack5",
  webpackFinal: async (config) => {
    // Inject postcss-loader into the CSS rule so Tailwind CSS v4 is processed
    const cssRule = config.module.rules.find(
      (rule) => rule.sideEffects === true && rule.use?.some?.((u) => typeof u === 'string' && u.includes('style-loader'))
    );
    if (cssRule) {
      cssRule.use.push({
        loader: 'postcss-loader',
        options: {
          postcssOptions: {
            config: './postcss.config.js',
          },
        },
      });
    }
    return config;
  },
};

export default config;
